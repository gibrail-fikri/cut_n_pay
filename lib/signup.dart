import 'package:flutter/material.dart';
import 'package:cut_n_pay/login.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';
import 'package:progress_dialog/progress_dialog.dart';

void main() => runApp(Signup());

class Signup extends StatefulWidget {
  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  TextEditingController _nameController = new TextEditingController();
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _passController = new TextEditingController();
  TextEditingController _confPassController = new TextEditingController();
  TextEditingController _phoneController = new TextEditingController();
  GlobalKey<FormState> _key = new GlobalKey();
  bool _isChecked = false;
  String urlSignup =
      "https://cutnpay.000webhostapp.com/cutnpay/php/register.php";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Sign up'),
          centerTitle: true,
          backgroundColor: Colors.black,
        ),
        body: Form(
          key: _key,
          child: Container(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 150,
                ),
                Card(
                    elevation: 5,
                    child: Container(
                        padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                        child: Column(
                          children: <Widget>[
                            TextFormField(
                              controller: _nameController,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                labelText: 'Name',
                                hintText: 'Input your name',
                                icon: Icon(Icons.work),
                              ),
                              validator: validateName,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                labelText: 'Email',
                                hintText: 'Input your email',
                                icon: Icon(Icons.alternate_email),
                              ),
                              validator: validateEmail,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              obscureText: true,
                              controller: _passController,
                              decoration: InputDecoration(
                                labelText: 'Password',
                                hintText: 'Input your password',
                                icon: Icon(Icons.lock),
                              ),
                              validator: validatePassword,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              obscureText: true,
                              controller: _confPassController,
                              decoration: InputDecoration(
                                labelText: 'Re-type Password',
                                hintText: 'Re-type your password',
                                icon: Icon(Icons.lock),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              controller: _phoneController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                labelText: 'Phone Number',
                                hintText: 'Input your phone number',
                                icon: Icon(Icons.phone),
                              ),
                              validator: validatePhone,
                            ),
                            Row(
                              children: <Widget>[
                                Checkbox(
                                  value: _isChecked,
                                  onChanged: (bool value) {
                                    _onChange(value);
                                  },
                                ),
                                Text(
                                  "By submitting this form, I agree to Cut N' Pay's ",
                                  style: TextStyle(fontSize: 16),
                                ),
                                GestureDetector(
                                    onTap: _showTerms,
                                    child: Text(
                                      'EULA',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ))
                              ],
                            ),
                            SizedBox(height: 30),
                            SizedBox(
                              width: double.infinity,
                              child: MaterialButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0)),
                                minWidth: 350,
                                height: 50,
                                child: Text('Submit'),
                                color: Colors.black,
                                textColor: Colors.white,
                                elevation: 15,
                                onPressed: _registerAccount,
                              ),
                            ),
                            SizedBox(height: 30),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text('Already registered?',
                                    style: TextStyle(
                                      fontSize: 18,
                                    )),
                                GestureDetector(
                                    onTap: _toLogin,
                                    child: Text('  Sign in',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold)))
                              ],
                            ),
                          ],
                        ))),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _toLogin() {
    Navigator.pop(context, MaterialPageRoute(builder: (context) => Login()));
  }

  void _registerAccount() {
    String password = _passController.text;
    String confPass = _confPassController.text;

    if (!_isChecked) {
      Toast.show("Please Accept EULA before proceeding", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }

    if (password != confPass) {
      Toast.show("Password does not match each other", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text(
            "Confirm Registration",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: new Container(
            height: 50,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[Text("Confirm register new account?")],
            ),
          ),
          actions: <Widget>[
            new FlatButton(
                child: new Text("Yes"),
                onPressed: () {
                  Navigator.of(context).pop();
                  _register();
                }),
            new FlatButton(
              child: new Text("No"),
              onPressed: () {
                Navigator.of(context).pop();
                return;
              },
            ),
          ],
        );
      },
    );
  }

  void _onChange(bool value) {
    setState(() {
      _isChecked = value;
    });
  }

  void _showTerms() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: new Text("End User License Agreement (EULA)"),
              content: new Container(
                  height: 700,
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: RichText(
                            softWrap: true,
                            textAlign: TextAlign.justify,
                            text: TextSpan(
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                ),
                                text:
                                    "This End-User License Agreement is a legal agreement between you and ChopChop. This EULA agreement governs your acquisition and use of our software (CUT N’ PAY) directly from ChopChop or indirectly through a ChopChop authorized reseller or distributor (a Reseller).Please read this EULA agreement carefully before completing the installation process and using the CUT N’ PAY software. It provides a license to use the CUT N’ PAY software and contains warranty information and liability disclaimers. If you register for a free trial of the CUT N’ PAY software, this EULA agreement will also govern that trial. By clicking accept or installing and/or using the CUT N’ PAY software, you are confirming your acceptance of the Software and agreeing to become bound by the terms of this EULA agreement. If you are entering into this EULA agreement on behalf of a company or other legal entity, you represent that you have the authority to bind such entity and its affiliates to these terms and conditions. If you do not have such authority or if you do not agree with the terms and conditions of this EULA agreement, do not install or use the Software, and you must not accept this EULA agreement. This EULA agreement shall apply only to the Software supplied by ChopChop herewith regardless of whether other software is referred to or described herein. The terms also apply to any ChopChop updates, supplements, Internet-based services, and support services for the Software, unless other terms accompany those items on delivery. If so, those terms apply. This EULA was created by EULA Template for CUT N’ PAY. ChopChop shall at all times retain ownership of the Software as originally downloaded by you and all subsequent downloads of the Software by you. The Software (and the copyright, and other intellectual property rights of whatever nature in the Software, including any modifications made thereto) are and shall remain the property of ChopChop. ChopChop reserves the right to grant licences to use the Software to third parties.")),
                      )
                    ],
                  )));
        });
  }

  void _register() {
    if (_key.currentState.validate()) {
      String name = _nameController.text;
      String email = _emailController.text;
      String phone = _phoneController.text;
      String password = _passController.text;

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
      http.post(urlSignup, body: {
        "name": name,
        "email": email,
        "password": password,
        "phone": phone,
      }).then((res) {
        if (res.body == "failed") {
          Toast.show("Registration failed", context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
          prog.dismiss();
        } else {
          Navigator.pop(context,
              MaterialPageRoute(builder: (BuildContext context) => Login()));
          Toast.show("Registration success", context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
          prog.dismiss();
        }
      }).catchError((err) {
        print(err);
      });
    }
  }

  String validateName(String value) {
    String patttern = r'(^[a-zA-Z ]*$)';
    RegExp regExp = new RegExp(patttern);
    if (value.length == 0) {
      return "Name is missing";
    } else if (!regExp.hasMatch(value)) {
      return "Name must only consist of letters";
    }
    return null;
  }

  String validateEmail(String value) {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return "Email is missing";
    } else if (!regExp.hasMatch(value)) {
      return "Invalid Email";
    } else {
      return null;
    }
  }

  String validatePassword(String value) {
    if (value.length == 0) {
      return "Password is missing";
    } else if (value.length < 8) {
      return "Password length must be 8 characters or more";
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
