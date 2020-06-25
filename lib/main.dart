import 'dart:convert';
import 'package:cut_n_pay/paymenthistory.dart';
import 'package:cut_n_pay/shop.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;
import 'user.dart';
import 'package:cut_n_pay/user.dart';
import 'package:cut_n_pay/orderpage.dart';

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
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: null,
      child: Scaffold(
        backgroundColor: Colors.grey,
        drawer: mainDrawer(context),
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text('Shops'),
          actions: <Widget>[],
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
    var res = await http.get(
        Uri.encodeFull(
            "https://cutnpay.000webhostapp.com/cutnpay/php/shops.json"),
        headers: {"Accept": "application/json"});
    if (res.statusCode == 200) {
      setState(() {
        var extractdata = json.decode(res.body);
        _shops = extractdata['shops'];
        _load = false;
      });
    } else {
      print("error");
    }
  }

  Widget mainDrawer(BuildContext context) {
    return Theme(
      data: ThemeData.dark(),
      child: Drawer(
          child: ListView(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountEmail: Text(widget.user.getemail()),
            accountName: Text(widget.user.getname()),
            currentAccountPicture: CircleAvatar(
              backgroundColor:
                  Theme.of(context).platform == TargetPlatform.android
                      ? Colors.white
                      : Colors.white,
              backgroundImage: NetworkImage(
                  server + "/profile/${widget.user.getemail()}/profilepic.png"),
            ),
          ),
          Card(
            color: Colors.grey,
            child: ListTile(
                leading: Icon(Icons.person),
                title: Text(
                  "My profile",
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 18,
                  ),
                ),
                trailing: Icon(Icons.arrow_forward),
                onTap: () => {
                      Navigator.pop(context),
                    }),
          ),
          Card(
            color: Colors.grey,
            child: ListTile(
                leading: Icon(Icons.attach_money),
                title: Text(
                  "Payment history",
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 18,
                  ),
                ),
                trailing: Icon(Icons.arrow_forward),
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
            color: Colors.grey,
            child: ListTile(
                leading: Icon(Icons.favorite),
                title: Text(
                  "Favourite",
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 18,
                  ),
                ),
                trailing: Icon(Icons.arrow_forward),
                onTap: () => {
                      Navigator.pop(context),
                    }),
          ),
          Card(
            color: Colors.grey,
            child: ListTile(
                leading: Icon(Icons.credit_card),
                title: Text(
                  "Payment method",
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 18,
                  ),
                ),
                trailing: Icon(Icons.arrow_forward),
                onTap: () => {
                      Navigator.pop(context),
                    }),
          ),
          Card(
            color: Colors.grey,
            child: ListTile(
                leading: Icon(Icons.info),
                title: Text(
                  "App info",
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 18,
                  ),
                ),
                trailing: Icon(Icons.arrow_forward),
                onTap: () => {
                      Navigator.pop(context),
                    }),
          ),
        ],
      )),
    );
  }

  _showPage() {
    if (_load == false) {
      return GridView.count(
          crossAxisCount: 2,
          children: List.generate(_shops.length, (index) {
            return InkWell(
                child: Card(
                  color: Colors.black38,
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
                    padding: const EdgeInsets.all(5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        ClipRect(
                          child: CachedNetworkImage(
                              height: 180,
                              fit: BoxFit.cover,
                              imageUrl:
                                  "https://cutnpay.000webhostapp.com/cutnpay/images/${_shops[index]['imagename']}"),
                        ),
                        RaisedButton(
                          child: Text(
                            "${_shops[index]['loc_name']}",
                            style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey),
                          ),
                          color: Colors.black26,
                          elevation: 10,
                          onPressed: () => {_toShop(index)},
                        ),
                        Text(
                          'RM ' + "${_shops[index]['price']}" + ".00",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                onTap: () {
                  _toShop(index);
                });
          }));
    }
  }

  void _toShop(index) {
    Shop shop = new Shop(
        _shops[index]['pid'],
        _shops[index]['loc_name'],
        _shops[index]['price'] + .0,
        _shops[index]['type'],
        _shops[index]['contact'],
        _shops[index]['address'],
        _shops[index]['imagename']);
    print(_shops[index]['price']);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => Order(
                  shop: shop,
                  user: widget.user,
                )));
  }
}
