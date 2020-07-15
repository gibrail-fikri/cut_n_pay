import 'package:flutter/material.dart';
import 'user.dart';
import 'package:cut_n_pay/user.dart';
import 'dart:async';
import 'package:toast/toast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:http/http.dart' as http;

void main() => runApp(ProfileScreen());
bool _editing;
double _cardHeight = 220;

class ProfileScreen extends StatefulWidget {
  final User user;
  const ProfileScreen({Key key, this.user}) : super(key: key);
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  TextEditingController _newNameController = new TextEditingController();
  TextEditingController _newPhoneController = new TextEditingController();
  GlobalKey<FormState> _key = new GlobalKey();
  GlobalKey<FormState> _key2 = new GlobalKey();

  @override
  void initState() {
    super.initState();
    _editing = true;
    _cardHeight = 220;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: null,
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.black,
            title: Text(widget.user.getname()),
          ),
          body: Container(
              child: Column(
            children: <Widget>[
              SizedBox(
                height: 15,
              ),
              _showprofile()
            ],
          ))),
    );
  }

  _showprofile() {
    return Column(
      children: <Widget>[
        SizedBox(
          height: _cardHeight,
          width: 600,
          child: Card(
            child: Column(children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(10),
                child: Text("User info",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                        fontWeight: FontWeight.bold)),
              ),
              Visibility(
                visible: _editing,
                child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(widget.user.getname(),
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 24,
                            )))),
              ),
              Visibility(
                visible: !_editing,
                child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: Form(
                          key: _key,
                          child: TextFormField(
                            style: TextStyle(fontSize: 20),
                            controller: _newNameController,
                            decoration: InputDecoration(
                              labelText: 'Enter new name',
                              hintText: widget.user.getname() +
                                  " (Name must be more than 5 letters)",
                            ),
                            validator: validateName,
                          ),
                        ))),
              ),
              Padding(
                  padding: const EdgeInsets.all(10),
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(widget.user.getemail(),
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 24,
                          )))),
              Visibility(
                visible: _editing,
                child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(widget.user.getphone(),
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 24,
                            )))),
              ),
              Visibility(
                visible: !_editing,
                child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: Form(
                          key: _key2,
                          child: TextFormField(
                            controller: _newPhoneController,
                            style: TextStyle(fontSize: 20),
                            decoration: InputDecoration(
                              labelText: 'Enter new phone number',
                              hintText: widget.user.getphone(),
                            ),
                            validator: validatePhone,
                          ),
                        ))),
              ),
            ]),
          ),
        ),
        Visibility(
          visible: _editing,
          child: RaisedButton(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            color: Colors.black,
            textColor: Colors.white,
            child: Text("Edit info",
                style: TextStyle(
                  fontSize: 18,
                )),
            onPressed: () {
              if (widget.user.getemail() != "cutnpayguest@gmail.com" &&
                  widget.user.getemail() != "cutnpayadmin@gmail.com") {
                setState(() {
                  _editinfo();
                });
              } else {
                Toast.show(
                    "Please register or sign in to use this feature", context,
                    duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
              }
            },
          ),
        ),
        Visibility(
          visible: !_editing,
          child: RaisedButton(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            color: Colors.black,
            textColor: Colors.white,
            child: Text("Submit",
                style: TextStyle(
                  fontSize: 18,
                )),
            onPressed: () {
              setState(() {
                _submitChange();
              });
            },
          ),
        ),
      ],
    );
  }

  void _submitChange() {
    String urlChangeinfo =
        "https://cutnpay.000webhostapp.com/cutnpay/php/changeinfo.php";

    if (_key.currentState.validate() && _key2.currentState.validate()) {
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
              color: Colors.black,
              fontSize: 19.0,
              fontWeight: FontWeight.w600));
      prog.show();
      http.post(urlChangeinfo, body: {
        "email": widget.user.getemail(),
        "name": _newNameController.text,
        "phone": _newPhoneController.text,
      }).then((res) {
        if (res.body == " failed") {
          Navigator.pop(
              context,
              Toast.show("Process could not be completed", context,
                  duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM));
        } else if (res.body == " success") {
          setState(() {
            Navigator.pop(
                context,
                Toast.show("Change Successful", context,
                    duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM));
            widget.user.setname(_newNameController.text);
            widget.user.setphone(_newPhoneController.text);
            _editing = !_editing;
            _cardHeight = 220;
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

  Future<void> _editinfo() async {
    _editing = !_editing;
    _cardHeight = 320;
  }

  String validateName(String value) {
    String patttern = r'(^[a-zA-Z ]*$)';
    RegExp regExp = new RegExp(patttern);
    if (value.length == 0) {
      return "Name is missing";
    } else if (value.length < 5) {
      return "Name must be atleast 5 letters";
    } else if (!regExp.hasMatch(value)) {
      return "Name must only consist of letters";
    } else if (value.length > 15) {
      return "Username must be less than 15 letters";
    }
    return null;
  }

  String validatePhone(String value) {
    String patttern = r'(^[0-9]*$)';
    RegExp regExp = new RegExp(patttern);
    if (value.length == 0) {
      return "Phone number is missing";
    } else if (!regExp.hasMatch(value)) {
      return "Phone number must no contain text";
    }
    return null;
  }
}
