import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';
import 'package:progress_dialog/progress_dialog.dart';

void main() => runApp(Approval());

class Approval extends StatefulWidget {
  @override
  _ApprovalState createState() => _ApprovalState();
}

class _ApprovalState extends State<Approval> {
  List _approvaldata;
  @override
  void initState() {
    super.initState();
    _loadtoApprove();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: null,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text('Approval'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: Container(child: FutureBuilder(
            builder: (context, snapshot) {
              return ListView.builder(
                itemCount: _approvaldata == null ? 0 : _approvaldata.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                      child: ListTile(
                    title: Text(
                      _approvaldata[index]['name'],
                      style: TextStyle(fontSize: 18),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "Price: RM" + _approvaldata[index]['price'],
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "Address: " + _approvaldata[index]['address'],
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    onTap: () => _confirmApprove(index),
                  ));
                },
              );
            },
          )),
        ),
      ),
    );
  }

  Future<void> _loadtoApprove() async {
    String urlLoadApproval =
        "https://cutnpay.000webhostapp.com/cutnpay/php/loadapproval.php?";
    await http.post(urlLoadApproval, body: {}).then((res) {
      if (res.body == " nodata") {
        setState(() {
          _approvaldata = null;
          Toast.show("Nothing to approve", context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        });
      } else {
        setState(() {
          var extractdata = json.decode(res.body);
          _approvaldata = extractdata["shops"];
        });
      }
    }).catchError((err) {
      print(err);
    });
  }

  _confirmApprove(int index) async {
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

    String urlApprove =
        "https://cutnpay.000webhostapp.com/cutnpay/php/approve.php";
    await http
        .post(urlApprove, body: {"id": _approvaldata[index]['id']}).then((res) {
      if (res.body == " success") {
        setState(() {
          Toast.show("Successfully approved", context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
          _loadtoApprove();
          prog.dismiss();
        });
      } else {
        setState(() {
          Toast.show("Failed to approve", context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
          _loadtoApprove();
          prog.dismiss();
        });
      }
    }).catchError((err) {
      print(err);
    });
  }
}
