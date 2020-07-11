import 'package:flutter/material.dart';
import 'package:cut_n_pay/signup.dart';
import 'package:cut_n_pay/main.dart';
import 'user.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';

void main() => runApp(Login());

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool passwordInvisible = true;
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _passController = new TextEditingController();
  String urlLogin = "https://cutnpay.000webhostapp.com/cutnpay/php/login.php--"; // remove bars later
  @override
  void initState() {
    super.initState();
    print("INITSTATE UP");
    passwordInvisible = true;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Sign in'),
          centerTitle: true,
          backgroundColor: Colors.black,
        ),
        body: Center(
          child: Container(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 30,
              ),
              Image.asset(
                'assets/images/BarbLogo.png',
                scale: 0.5,
              ),
              SizedBox(
                height: 30,
              ),
              Card(
                  elevation: 5,
                  child: Container(
                      padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                      child: Column(
                        children: <Widget>[
                          TextField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              labelText: 'Email',
                              hintText: 'Enter your email',
                              icon: Icon(Icons.alternate_email),
                              //errorText: validate(_emailController.text)
                            ),
                          ),
                          SizedBox(height: 20),
                          TextField(
                            obscureText: passwordInvisible,
                            controller: _passController,
                            decoration: InputDecoration(
                                labelText: 'Password',
                                hintText: 'Enter your password',
                                icon: Icon(Icons.lock),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    passwordInvisible
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: Theme.of(context).primaryColorDark,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      passwordInvisible = !passwordInvisible;
                                    });
                                  },
                                )
                                //errorText: validate(_passController.text)
                                ),
                          ),
                          SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Checkbox(
                                value: false,
                                onChanged: (bool value) {
                                  //_onRememberMeChanged(value);
                                },
                              ),
                              Text('Remember Me ',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                              GestureDetector(
                                  onTap: null,
                                  child: Text(
                                      '                                                               Forgot password?',
                                      style: TextStyle(fontSize: 16)))
                            ],
                          ),
                        ],
                      ))),
              SizedBox(height: 20),
              MaterialButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0)),
                minWidth: 350,
                height: 50,
                child: Text('Log in', style: TextStyle(fontSize: 24)),
                color: Colors.black,
                textColor: Colors.white,
                elevation: 5,
                onPressed: _login,
              ),
              SizedBox(
                height: 225,
              ),
              Text('Don\'t have an account?', style: TextStyle(fontSize: 18)),
              SizedBox(height: 10),
              MaterialButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0)),
                minWidth: 175,
                height: 50,
                child: Text('Sign up', style: TextStyle(fontSize: 24)),
                color: Colors.black,
                textColor: Colors.white,
                elevation: 5,
                onPressed: _signup,
              ),
              GestureDetector(
                  onTap: _toMainScreenAsGuest,
                  child:
                      Text('Continue as Guest', style: TextStyle(fontSize: 16)))
            ],
          )),
        ),
      ),
    );
  }

//PROGRESS
  void _login() {
    try {
      ProgressDialog pr = new ProgressDialog(context,
          type: ProgressDialogType.Normal, isDismissible: false);
      pr.style(message: "Log in...");
      pr.show();
      String _email = _emailController.text;
      String _password = _passController.text;
      http.post(urlLogin, body: {
        "email": _email,
        "password": _password,
      })
          //.timeout(const Duration(seconds: 4))
          .then((res) {
        print(res.body);
        var string = res.body;
        List userdata = string.split(",");
        if (userdata[0] == "success") {
          User _user = new User(
              userdata[1],
              _email,
              userdata[3],
              _password,
              );
          pr.dismiss();
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => Mainscreen(
                        user: _user,
                      )));
        } else {
          pr.dismiss();
          Toast.show("Login failed", context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        }
      }).catchError((err) {
        print(err);
        pr.dismiss();
      });
    } on Exception catch (_) {
      Toast.show("Error", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
  }
//PROGRESS


  void _signup() {
    Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) => Signup()));
  }

  void _toMainScreenAsGuest() {
    User _user = new User(
        "cutnpayguest", "cutnpayguest@gmail.com", "012-3456789", "12345");

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => Mainscreen(
                  user: _user,
                )));
  }
}
