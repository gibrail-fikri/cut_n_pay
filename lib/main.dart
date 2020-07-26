import 'dart:convert';
import 'dart:math';
import 'package:cut_n_pay/addshop.dart';
import 'package:cut_n_pay/approval.dart';
import 'package:cut_n_pay/paymenthistory.dart';
import 'package:cut_n_pay/profilescreen.dart';
import 'package:cut_n_pay/shop.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;
import 'user.dart';
import 'package:cut_n_pay/user.dart';
import 'package:cut_n_pay/orderpage.dart';
import 'package:geolocator/geolocator.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

Position _currentLocation;
List<Placemark> placemark;
RefreshController _refreshController = RefreshController(initialRefresh: false);
bool admin = false, isUser = false;
void main() => runApp(Mainscreen());

class Mainscreen extends StatefulWidget {
  final User user;
  const Mainscreen({Key key, this.user}) : super(key: key);
  @override
  _MainscreenState createState() => _MainscreenState();
}

class _MainscreenState extends State<Mainscreen> {
  double screenHeight, screenWidth;
  List _shops;
  bool _load;
  String server = "https://cutnpay.000webhostapp.com/cutnpay";
  @override
  void initState() {
    super.initState();
    _load = true;
    _loadData();
    _getCurrentLocation();
    if (widget.user.getemail() == "cutnpayadmin@gmail.com") {
      admin = true;
    } else {
      admin = false;
    }
    if (widget.user.getemail() != "cutnpayguest@gmail.com") {
      isUser = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    _loadData();
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: null,
      child: Scaffold(
        backgroundColor: Colors.grey,
        drawer: mainDrawer(context),
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text(
            'Shops',
            style: TextStyle(fontSize: 18),
          ),
          actions: <Widget>[
            Visibility(
              visible: isUser,
              child: GestureDetector(
                onTap: _toAddShop,
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8),
          child: Container(
            child: _showPage(),
          ),
        ),
      ),
    );
  }

  Future<void> _loadData() async {
    String urlLoadShops = server + "/php/load_shop.php";
    await http.post(urlLoadShops, body: {}).then((res) {
      if (res.body == "nodata") {
        setState(() {
          _shops = null;
          _load = false;
        });
      } else {
        setState(() {
          var extractdata = json.decode(res.body);
          _shops = extractdata["shops"];
          _load = false;
        });
      }
    }).catchError((err) {
      print(err);
    });
  }

  Widget mainDrawer(BuildContext context) {
    return Theme(
      data: ThemeData.dark(),
      child: Drawer(
          child: ListView(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountEmail: null,
            accountName: Text(
              widget.user.getname(),
              style: TextStyle(fontSize: 22),
            ),
            currentAccountPicture: CircleAvatar(
              backgroundColor:
                  Theme.of(context).platform == TargetPlatform.android
                      ? Colors.black
                      : Colors.white,
              child: Text(
                widget.user.getname().toString().substring(0, 1).toUpperCase(),
                style: TextStyle(fontSize: 40.0),
              ),
            ),
          ),
          Card(
            color: Colors.white,
            child: ListTile(
                leading: Icon(
                  Icons.person,
                  color: Colors.black,
                ),
                title: Text(
                  "My profile",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                  ),
                ),
                trailing: Icon(Icons.arrow_forward, color: Colors.black),
                onTap: () => {
                      Navigator.pop(context),
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => ProfileScreen(
                                    user: widget.user,
                                  ))).then((value) {
                        setState(() {});
                      })
                    }),
          ),
          Card(
            color: Colors.white,
            child: ListTile(
                leading: Icon(Icons.attach_money, color: Colors.black),
                title: Text(
                  "Payment history",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                  ),
                ),
                trailing: Icon(Icons.arrow_forward, color: Colors.black),
                onTap: () => {
                      Navigator.pop(context),
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  PaymentHistoryScreen(
                                    user: widget.user,
                                  )))
                    }),
          ),
          Card(
            color: Colors.white,
            child: ListTile(
                leading: Icon(Icons.info, color: Colors.black),
                title: Text(
                  "App info",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                  ),
                ),
                trailing: Icon(Icons.arrow_forward, color: Colors.black),
                onTap: () => {
                      Navigator.pop(context),
                      _appinfo(),
                    }),
          ),
          Visibility(
            visible: admin,
            child: Card(
              color: Colors.white,
              child: ListTile(
                  leading: Icon(
                    Icons.check_box,
                    color: Colors.black,
                  ),
                  title: Text(
                    "Approval (admin)",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                    ),
                  ),
                  trailing: Icon(Icons.arrow_forward, color: Colors.black),
                  onTap: () => {
                        Navigator.pop(context),
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) => Approval()))
                      }),
            ),
          ),
          Card(
            color: Colors.white,
            child: ListTile(
                leading: Icon(
                  Icons.exit_to_app,
                  color: Colors.black,
                ),
                title: Text(
                  "Logout",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                  ),
                ),
                trailing: Icon(Icons.arrow_forward, color: Colors.black),
                onTap: () => {Navigator.pop(context), Navigator.pop(context)}),
          ),
        ],
      )),
    );
  }

  _showPage() {
    if (_load == false) {
      return SmartRefresher(
        controller: _refreshController,
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        child: GridView.count(
            crossAxisCount: 2,
            children: List.generate(_shops.length, (index) {
              return InkWell(
                  child: Card(
                    color: Colors.black87,
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(5),
                      ),
                      side: BorderSide(
                        color: Colors.black,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(7.5),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          ClipRect(
                            child: CachedNetworkImage(
                                height: 110,
                                fit: BoxFit.cover,
                                imageUrl:
                                    "https://cutnpay.000webhostapp.com/cutnpay/images/${_shops[index]['imagename']}"),
                          ),
                          Text(
                            "${_shops[index]['name']}",
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          Text(
                              _calculatedistance(index).toStringAsFixed(2) +
                                  "km",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                              )),
                          Text(
                            'RM ' + "${_shops[index]['price']}" + ".00",
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                  onTap: () {
                    _toShop(index);
                  });
            })),
      );
    }
  }

  void _toShop(index) {
    Shop shop = new Shop(
        _shops[index]['id'].toString(),
        _shops[index]['name'],
        double.parse(_shops[index]['price']),
        _shops[index]['type'],
        _shops[index]['contact'],
        _shops[index]['address'],
        _shops[index]['imagename'],
        double.parse(_shops[index]['lat']),
        double.parse(_shops[index]['lon']),
        _shops[index]['owneremail']);

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => Order(
                  shop: shop,
                  user: widget.user,
                ))).then((value) {
      setState(() {});
    });
  }

  Future<void> _getCurrentLocation() async {
    try {
      _currentLocation = await Geolocator()
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    } catch (e) {
      print(e);
    }
  }

  _calculatedistance(int index) {
    double dis = sqrt(pow(
            (_currentLocation.latitude - double.parse(_shops[index]['lat'])),
            2) +
        pow(_currentLocation.longitude - double.parse(_shops[index]['lon']),
            2));
    return dis * 100;
  }

  _appinfo() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Center(child: Text("App Info")),
            content: Container(
                child: Text(
              "CutNPay project, created for STIW2044 Group A \nCreated by Gibrail Fikri bin Yusni 264195\nVersion 1.0",
              style: TextStyle(color: Colors.black),
            )),
          );
        });
  }

  void _onRefresh() async {
    setState(() {
      _getCurrentLocation();
    });
    await Future.delayed(Duration(milliseconds: 500));
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    await Future.delayed(Duration(milliseconds: 500));
    _refreshController.loadComplete();
  }

  void _toAddShop() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => AddShop(
                  email: widget.user.getemail(),
                  currentLocation: _currentLocation,
                ))).then((value) {
      setState(() {});
    });
  }
}
