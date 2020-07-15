import 'package:cut_n_pay/payment.dart';
import 'package:flutter/material.dart';
import 'shop.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cut_n_pay/user.dart';
import 'package:intl/intl.dart';
import 'package:random_string/random_string.dart';
import 'package:toast/toast.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:http/http.dart' as http;

bool _check1, _check2, _check3;
double totalprice, addservice;
CameraPosition _curpos;
Completer<GoogleMapController> _controller = Completer();
Set<Marker> _markers = {};
bool admin=false;
TextEditingController _newPriceController = new TextEditingController();

class Order extends StatefulWidget {
  final Shop shop;
  final User user;
  Order({Key key, this.shop, this.user}) : super(key: key);
  @override
  _Orderstate createState() => _Orderstate();
}

class _Orderstate extends State<Order> {
  @override
  void initState() {
    super.initState();
    totalprice = widget.shop.getprice();
    addservice = 0;
    _check1 = false;
    _check2 = false;
    _check3 = false;
    if (widget.user.getemail() == "cutnpayadmin@gmail.com") {
      admin = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: null,
      child: Scaffold(
        backgroundColor: Colors.grey,
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Center(
            child: Text(
              '${widget.shop.getlocname()}',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          actions: <Widget>[
            Visibility(
              visible: admin,
              child: GestureDetector(
                child: Icon(
                  Icons.edit,
                  color: Colors.white,
                  size: 30,
                ),
                onTap: () => _editValue(),
              ),
            )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  child: CachedNetworkImage(
                      width: double.infinity,
                      fit: BoxFit.cover,
                      imageUrl:
                          "https://cutnpay.000webhostapp.com/cutnpay/images/${widget.shop.getimagename()}"),
                ),
                Padding(padding: const EdgeInsets.all(10), child: _extras()),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: _paymentinfo(),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    RawMaterialButton(
                      onPressed: () {},
                      elevation: 2.0,
                      fillColor: Colors.black,
                      child: GestureDetector(
                        child: Icon(
                          Icons.phone,
                          size: 35.0,
                          color: Colors.white,
                        ),
                        onTap: () {
                          launch("tel: ${widget.shop.getcontact()}");
                        },
                      ),
                      padding: EdgeInsets.all(15.0),
                      shape: CircleBorder(),
                    ),
                    RawMaterialButton(
                      onPressed: () {},
                      elevation: 2.0,
                      fillColor: Colors.black,
                      child: GestureDetector(
                          child: Icon(
                            Icons.map,
                            size: 35.0,
                            color: Colors.white,
                          ),
                          onTap: () {
                            _loadMap();
                          }),
                      padding: EdgeInsets.all(15.0),
                      shape: CircleBorder(),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  _paymentinfo() {
    return Container(
        child: Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      shadowColor: Colors.black,
      color: Colors.black12,
      elevation: 3,
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 15,
          ),
          Text("Place an order",
              style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black)),
          SizedBox(height: 10),
          Container(
              padding: EdgeInsets.fromLTRB(50, 0, 50, 0),
              child: Table(
                  defaultColumnWidth: FlexColumnWidth(1.0),
                  columnWidths: {
                    0: FlexColumnWidth(7),
                    1: FlexColumnWidth(3),
                  },
                  children: [
                    TableRow(children: [
                      TableCell(
                        child: Container(
                            alignment: Alignment.centerLeft,
                            height: 20,
                            child: Text("Regular haircut ",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 18))),
                      ),
                      TableCell(
                        child: Container(
                          alignment: Alignment.centerLeft,
                          height: 20,
                          child: Text(
                              "RM" +
                                      widget.shop
                                          .getprice()
                                          .toStringAsFixed(2) ??
                                  "0.0",
                              style:
                                  TextStyle(fontSize: 18, color: Colors.black)),
                        ),
                      ),
                    ]),
                    TableRow(children: [
                      TableCell(
                        child: Container(
                            alignment: Alignment.centerLeft,
                            height: 20,
                            child: Text("Additional services",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 18))),
                      ),
                      TableCell(
                        child: Container(
                          alignment: Alignment.centerLeft,
                          height: 20,
                          child: Text(
                              "RM" + addservice.toStringAsFixed(2) ?? "0.0",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 18)),
                        ),
                      ),
                    ]),
                    TableRow(children: [
                      TableCell(
                        child: Container(
                            alignment: Alignment.centerLeft,
                            height: 20,
                            child: Text("Total Amount ",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 18))),
                      ),
                      TableCell(
                        child: Container(
                          alignment: Alignment.centerLeft,
                          height: 20,
                          child: Text(
                              "RM" + totalprice.toStringAsFixed(2) ?? "0.0",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 18)),
                        ),
                      ),
                    ]),
                  ])),
          SizedBox(
            height: 10,
          ),
          MaterialButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            minWidth: 200,
            height: 35,
            child: Text('Place order'),
            color: Colors.black,
            textColor: Colors.white,
            elevation: 10,
            onPressed: toPayment,
          ),
        ],
      ),
    ));
  }

  Future<void> toPayment() async {
    var now = new DateTime.now();
    var formatter = new DateFormat('ddMMyyyy-');
    if (widget.user.getemail() != "cutnpayguest@gmail.com" &&
        widget.user.getemail() != "cutnpayadmin@gmail.com") {
      String orderid = widget.user.getemail().substring(1, 4) +
          "-" +
          formatter.format(now) +
          randomAlphaNumeric(6);
      await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => PaymentScreen(
                    shop: widget.shop,
                    user: widget.user,
                    orderid: orderid,
                    price: totalprice,
                  )));
    } else {
      Toast.show("Please register or sign in to use this feature", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
  }

  _extras() {
    return Container(
        child: Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      shadowColor: Colors.black,
      color: Colors.black12,
      elevation: 3,
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 15,
          ),
          Text("Additional services",
              style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black)),
          SizedBox(height: 10),
          Container(
              padding: EdgeInsets.fromLTRB(50, 0, 50, 0),
              child: Table(
                  defaultColumnWidth: FlexColumnWidth(1.0),
                  columnWidths: {
                    0: FlexColumnWidth(7),
                    1: FlexColumnWidth(3),
                  },
                  children: [
                    TableRow(children: [
                      TableCell(
                        child: CheckboxListTile(
                          title: Text(
                            "Hairwash                                    +RM5.00",
                            style: TextStyle(fontSize: 18),
                          ),
                          onChanged: (bool value) {
                            _ischecked1(value);
                          },
                          value: _check1,
                        ),
                      ),
                    ]),
                    TableRow(children: [
                      TableCell(
                        child: CheckboxListTile(
                          title: Text(
                            "Rebonding                                 +RM12.00",
                            style: TextStyle(fontSize: 18),
                          ),
                          onChanged: (bool value) {
                            _ischecked2(value);
                          },
                          value: _check2,
                        ),
                      ),
                    ]),
                    TableRow(children: [
                      TableCell(
                        child: CheckboxListTile(
                          title: Text(
                            "Hair Coloring                             +RM16.00",
                            style: TextStyle(fontSize: 18),
                          ),
                          onChanged: (bool value) {
                            _ischecked3(value);
                          },
                          value: _check3,
                        ),
                      ),
                    ]),
                  ])),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    ));
  }

  void _ischecked1(bool value) => setState(() {
        _check1 = value;
        if (_check1) {
          totalprice += 5;
          addservice += 5;
        } else {
          totalprice -= 5;
          addservice -= 5;
        }
      });

  void _ischecked2(bool value) => setState(() {
        _check2 = value;
        if (_check2) {
          totalprice += 12;
          addservice += 12;
        } else {
          totalprice -= 12;
          addservice -= 12;
        }
      });

  void _ischecked3(bool value) => setState(() {
        _check3 = value;
        if (_check3) {
          totalprice += 16;
          addservice += 16;
        } else {
          totalprice -= 16;
          addservice -= 16;
        }
      });

  void _loadMap() {
    _curpos = CameraPosition(
        target: LatLng(widget.shop.getlat(), widget.shop.getlon()), zoom: 20);
    setState(() {
      _markers.add(Marker(
          markerId: MarkerId(widget.shop.getpid()),
          position: LatLng(widget.shop.getlat(), widget.shop.getlon()),
          infoWindow: InfoWindow(title: '${widget.shop.getlocname()}')));
    });
    showDialog(
        context: context,
        builder: (context) {
          return Scaffold(
              body: GoogleMap(
            markers: _markers,
            initialCameraPosition: _curpos,
            mapType: MapType.normal,
            onMapCreated: (GoogleMapController controller) {
              try {
                _controller.complete(controller);
              } catch (e) {}
            },
          ));
        });
  }

  _editValue() {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Enter new price: "),
          content: TextFormField(
            controller: _newPriceController,
          ),
          actions: <Widget>[
            FlatButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.pop(context);
                _confirmChange();
              },
            )
          ],
        );
      },
    );
  }

  void _confirmChange() {
    String urlChangeprice =
        "https://cutnpay.000webhostapp.com/cutnpay/php/changeprice.php";

    ProgressDialog prog = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: true, showLogs: true);
    prog.style(
        message: 'Sending request...',
        borderRadius: 10.0,
        backgroundColor: Colors.white,
        progressWidget: RefreshProgressIndicator(),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        progress: 0.0,
        maxProgress: 100.0,
        progressTextStyle: TextStyle(
            color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
        messageTextStyle: TextStyle(
            color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600));
    prog.show();
    http.post(urlChangeprice, body: {
      "id": widget.shop.getpid(),
      "newprice": _newPriceController.text,
    }).then((res) {
      if (res.body == " failed") {
        Navigator.pop(
            context,
            Toast.show("Process could not be completed", context,
                duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM));
      } else if (res.body == " success") {
        setState(() {
          widget.shop.setprice(double.parse(_newPriceController.text));
          totalprice = widget.shop.getprice();
          addservice = 0;
          _check1 = false;
          _check2 = false;
          _check3 = false;
          Navigator.pop(
              context,
              Toast.show("Change Successful", context,
                  duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM));
        });
      } else {
        Navigator.pop(
            context,
            Toast.show("Server did not return any response", context,
                duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM));
      }
    }).catchError((err) {
      print(err);
    });
  }
}
