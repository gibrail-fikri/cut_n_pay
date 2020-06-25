import 'dart:async';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/material.dart';
import 'package:cut_n_pay/shop.dart';
import 'package:cut_n_pay/user.dart';

class PaymentScreen extends StatefulWidget {
  final Shop shop;
  final User user;
  final String orderid;
  PaymentScreen({Key key, this.shop, this.user, this.orderid})
      : super(key: key);

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  Completer<WebViewController> _controller = Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text('PAYMENT'),
          // backgroundColor: Colors.deepOrange,
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: WebView(
                initialUrl:
                    'https://cutnpay.000webhostapp.com/cutnpay/php/payment.php?email=' +
                        widget.user.getemail() +
                        '&mobile=' +
                        widget.user.getphone() +
                        '&name=' +
                        widget.user.getname() +
                        '&amount=' +
                        widget.shop.getprice().toString() +
                        '&orderid=' +
                        widget.orderid,
                javascriptMode: JavascriptMode.unrestricted,
                onWebViewCreated: (WebViewController webViewController) {
                  _controller.complete(webViewController);
                },
              ),
            )
          ],
        ));
  }
}
