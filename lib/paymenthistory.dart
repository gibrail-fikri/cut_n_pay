import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'user.dart';
import 'package:intl/intl.dart';
import 'package:cut_n_pay/user.dart';

void main() => runApp(PaymentHistoryScreen());

class PaymentHistoryScreen extends StatefulWidget {
  final User user;
  const PaymentHistoryScreen({Key key, this.user}) : super(key: key);
  @override
  _PaymentHistoryScreenState createState() => _PaymentHistoryScreenState();
}

class _PaymentHistoryScreenState extends State<PaymentHistoryScreen> {
  List _paymentdata;
  final f = new DateFormat('dd-MM-yyyy hh:mm a');
  String titlecenter = "Loading...";
  @override
  void initState() {
    super.initState();
    _loadPaymentHistory();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: null,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text('Payment History'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: Container(child: FutureBuilder(
            builder: (context, snapshot) {
              return ListView.builder(
                itemCount: _paymentdata == null ? 0 : _paymentdata.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    child: ListTile(
                      title: Text(
                        _paymentdata[index]['orderid'],
                        style: TextStyle(fontSize: 18),
                      ),
                      subtitle: Text(
                        "RM" + _paymentdata[index]['total'] + "0",
                        style: TextStyle(fontSize: 16),
                      ),
                      onTap: () => _loadOrderDetails(index),
                    ),
                  );
                },
              );
            },
          )),
        ),
      ),
    );
  }

  Future<void> _loadPaymentHistory() async {
    String urlLoadJobs =
        "https://cutnpay.000webhostapp.com/cutnpay/php/loadpaymenthistory.php?";
    await http
        .post(urlLoadJobs, body: {"email": widget.user.getemail()}).then((res) {
      print(res.body);
      if (res.body == "nodata") {
        setState(() {
          _paymentdata = null;
          titlecenter = "No Previous Payment";
        });
      } else {
        setState(() {
          var extractdata = json.decode(res.body);
          _paymentdata = extractdata["payment"];
        });
      }
    }).catchError((err) {
      print(err);
    });
  }

  _loadOrderDetails(int index) {}
}
