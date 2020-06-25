import 'package:cut_n_pay/payment.dart';
import 'package:flutter/material.dart';
import 'shop.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cut_n_pay/user.dart';
import 'package:intl/intl.dart';
import 'package:random_string/random_string.dart';

class Order extends StatefulWidget {
  final Shop shop;
  final User user;
  Order({Key key, this.shop, this.user}) : super(key: key);
  @override
  _Orderstate createState() => _Orderstate();
}

class _Orderstate extends State<Order> {
  double screenHeight, screenWidth;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
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
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: _paymentinfo(),
                ),
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
          Text("Payment",
              style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black)),
          SizedBox(height: 10),
          Container(
              padding: EdgeInsets.fromLTRB(50, 0, 50, 0),
              //color: Colors.red,
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
                            child: Text("Regular haircut: ",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black))),
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
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: Colors.black)),
                        ),
                      ),
                    ]),
                    TableRow(children: [
                      TableCell(
                        child: Container(
                            alignment: Alignment.centerLeft,
                            height: 20,
                            child: Text("Total Amount: ",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black))),
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
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black)),
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
                )));
  }
}
