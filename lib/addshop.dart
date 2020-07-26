import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:toast/toast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoder/geocoder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:random_string/random_string.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:intl/intl.dart';

void main() => runApp(AddShop());
int approved;
File file;
String _selimage, _selloc;
Position _currentPosition;
String curaddress, curstate;
Completer<GoogleMapController> _controller = Completer();
GoogleMapController gmcontroller;
CameraPosition _home;
MarkerId markerId1 = MarkerId("12");
Set<Marker> markers = Set();
double latitude, longitude;
String label;
CameraPosition _userpos;
double screenHeight, screenWidth;
var first;
var picked;
final picker = ImagePicker();

class AddShop extends StatefulWidget {
  final Position currentLocation;
  final email;
  const AddShop({Key key, this.currentLocation, this.email}) : super(key: key);

  @override
  _AddShopState createState() => _AddShopState();
}

class _AddShopState extends State<AddShop> {
  @override
  void initState() {
    super.initState();
    _selimage = "Press to select image";
    _selloc = "Press to select address";
    file = null;
    _getLocation();
    picked = null;
    if (widget.email == "cutnpayadmin@gmail.com") {
      approved = 1;
    } else {
      approved = 0;
    }
  }

  TextEditingController _locnameController = new TextEditingController();
  TextEditingController _priceController = new TextEditingController();
  TextEditingController _typeController = new TextEditingController();
  TextEditingController _contactController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Add a new shop'),
          centerTitle: true,
          backgroundColor: Colors.black,
          leading: GestureDetector(
            child: Icon(
              Icons.arrow_back,
            ),
            onTap: () => {Navigator.pop(context)},
          ),
        ),
        body: SingleChildScrollView(
          child: Form(
            child: Container(
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 75,
                  ),
                  Card(
                      elevation: 5,
                      child: Container(
                          padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                          child: Column(
                            children: <Widget>[
                              GestureDetector(
                                child: Text(_selimage),
                                onTap: () => {_selectImage()},
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              GestureDetector(
                                child: Text(_selloc),
                                onTap: () async {
                                  _selLocation();
                                },
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                controller: _locnameController,
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  labelText: 'Location name',
                                  hintText: 'Input location name',
                                  icon: Icon(Icons.bookmark),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                controller: _priceController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  labelText: 'Price',
                                  hintText: 'Input the standard price',
                                  icon: Icon(Icons.attach_money),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                controller: _typeController,
                                decoration: InputDecoration(
                                  labelText: 'Type',
                                  hintText: 'barber or salon',
                                  icon: Icon(Icons.queue),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                controller: _contactController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  labelText: 'Contact',
                                  hintText: 'Input contact of barber shop',
                                  icon: Icon(Icons.phone),
                                ),
                              ),
                              SizedBox(height: 30),
                              SizedBox(
                                width: double.infinity,
                                child: MaterialButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(20.0)),
                                  minWidth: 350,
                                  height: 50,
                                  child: Text('Submit'),
                                  color: Colors.black,
                                  textColor: Colors.white,
                                  elevation: 15,
                                  onPressed: () => {_submit()},
                                ),
                              ),
                              SizedBox(height: 30),
                            ],
                          ))),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _selectImage() async {
    await showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(title: new Text('Choose source'), actions: <Widget>[
              FlatButton(
                onPressed: () async {
                  Navigator.of(context, rootNavigator: true).pop();
                },
                child: new Text('Cancel'),
              ),
              FlatButton(
                onPressed: () async {
                  picked = await picker.getImage(source: ImageSource.gallery);
                  Navigator.of(context, rootNavigator: true).pop();
                  _setImage();
                },
                child: new Text('Gallery'),
              ),
              FlatButton(
                onPressed: () async {
                  picked = await picker.getImage(source: ImageSource.camera);
                  Navigator.of(context, rootNavigator: true).pop();
                  _setImage();
                },
                child: new Text('Camera'),
              )
            ]));
  }

  _submit() {
    var now = new DateTime.now();
    var formatter = new DateFormat('ddMMyyyy-');
    if (file != null) {
      String id =
          formatter.format(now).toString() + randomAlphaNumeric(5).toString();
      String uplImage = base64Encode(file.readAsBytesSync());
      String fileName = file.path.split("/").last;
      String urlAddShop =
          "https://cutnpay.000webhostapp.com/cutnpay/php/addshop.php";
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
      http.post(urlAddShop, body: {
        "id": id,
        "locname": _locnameController.text,
        "price": _priceController.text,
        "type": _typeController.text,
        "contact": _contactController.text,
        "address": curaddress,
        "lat": (first.coordinates.latitude).toString(),
        "lon": (first.coordinates.longitude).toString(),
        "filename": fileName,
        "owneremail": widget.email,
        "image": uplImage,
        'approved': approved.toString(),
      }).then((res) {
        if (res.body == " failed") {
          Toast.show("Something went wrong", context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
          prog.dismiss();
        } else if (res.body == " success") {
          Toast.show("Shop Successfully Added", context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
          setState(() {
            DefaultCacheManager manager = new DefaultCacheManager();
            manager.emptyCache();
          });
          prog.dismiss();
          Navigator.pop(context);
        } else {
          Toast.show("Server did not return any response", context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
          prog.dismiss();
        }
      }).catchError((err) {
        print(err);
      });
    } else {
      Toast.show("Please fill all forms", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
  }

  _getLocation() async {
    final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
    _currentPosition = await geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    final coordinates =
        new Coordinates(_currentPosition.latitude, _currentPosition.longitude);
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;
    setState(() {
      curaddress = first.addressLine;
      curstate = first.locality;
      if (curaddress != null) {
        latitude = _currentPosition.latitude;
        longitude = _currentPosition.longitude;
        return;
      }
    });
  }

  _getLocationfromlatlng(double lat, double lng, newSetState) async {
    final Geolocator geolocator = Geolocator()
      ..placemarkFromCoordinates(lat, lng);
    _currentPosition = await geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    final coordinates = new Coordinates(lat, lng);
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    first = addresses.first;
    newSetState(() {
      curstate = first.locality;

      curaddress = first.addressLine;
      if (curaddress != null) {
        latitude = _currentPosition.latitude;
        longitude = _currentPosition.longitude;
        return;
      }
    });
    setState(() {
      curstate = first.locality;

      curaddress = first.addressLine;
      if (curaddress != null) {
        latitude = _currentPosition.latitude;
        longitude = _currentPosition.longitude;
        return;
      }
    });
  }

  _loadMapDialog() {
    try {
      if (_currentPosition.latitude == null) {
        Toast.show("Location not available. Please wait...", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        _getLocation();
        return;
      }
      _controller = Completer();
      _userpos = CameraPosition(
        target: LatLng(latitude, longitude),
        zoom: 14.4746,
      );

      markers.add(Marker(
          markerId: markerId1,
          position: LatLng(latitude, longitude),
          infoWindow: InfoWindow(
            title: 'Current Location',
            snippet: 'Shop Location',
          )));

      showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, newSetState) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0))),
                title: Text(
                  "Select New Shop Location",
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                titlePadding: EdgeInsets.all(5),
                actions: <Widget>[
                  Text(
                    curaddress,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  Container(
                    height: screenHeight / 2 ?? 600,
                    width: screenWidth ?? 360,
                    child: GoogleMap(
                        mapType: MapType.normal,
                        initialCameraPosition: _userpos,
                        markers: markers.toSet(),
                        onMapCreated: (controller) {
                          _controller.complete(controller);
                        },
                        onTap: (newLatLng) {
                          _loadLoc(newLatLng, newSetState);
                        }),
                  ),
                  MaterialButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)),
                    height: 30,
                    child: Text('Close'),
                    color: Color.fromRGBO(101, 255, 218, 50),
                    textColor: Colors.black,
                    elevation: 10,
                    onPressed: () => {
                      markers.clear(),
                      _locchanged(),
                      Navigator.of(context).pop(false)
                    },
                  ),
                ],
              );
            },
          );
        },
      );
    } catch (e) {
      print(e);
      return;
    }
  }

  void _loadLoc(LatLng loc, newSetState) async {
    newSetState(() {
      markers.clear();
      latitude = loc.latitude;
      longitude = loc.longitude;
      _getLocationfromlatlng(latitude, longitude, newSetState);
      _home = CameraPosition(
        target: loc,
        zoom: 14,
      );
      markers.add(Marker(
          markerId: markerId1,
          position: LatLng(latitude, longitude),
          infoWindow: InfoWindow(
            title: 'New Location',
            snippet: 'Shop Location',
          )));
    });
    _userpos = CameraPosition(
      target: LatLng(latitude, longitude),
      zoom: 14,
    );
    _newhomeLocation();
  }

  Future<void> _newhomeLocation() async {
    gmcontroller = await _controller.future;
    gmcontroller.animateCamera(CameraUpdate.newCameraPosition(_home));
  }

  _selLocation() async {
    _loadMapDialog();
  }

  void _setImage() {
    if (picked != null) {
      setState(() {
        file = File(picked.path);
        _selimage = "Repick image";
      });
    } else {
      setState(() {
        file = File(picked.path);
        _selimage = "Press to select image";
      });
    }
  }

  _locchanged() {
    setState(() {
      _selloc = "Press to reselect address";
    });
  }
}
