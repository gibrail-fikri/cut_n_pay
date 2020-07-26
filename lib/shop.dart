class Shop {
  String _id;
  String _locName;
  double _price;
  String _type;
  String _contact;
  String _address;
  String _imagename;
  double _lat;
  double _lon;
  String _owneremail;

  Shop(
    String id,
    String locName,
    double price,
    String type,
    String contact,
    String address,
    String imagename,
    double lat,
    double lon,
    String owneremail,
  ) {
    this._id = id;
    this._locName = locName;
    this._price = price;
    this._type = type;
    this._contact = contact;
    this._address = address;
    this._imagename = imagename;
    this._lat = lat;
    this._lon = lon;
    this._owneremail = owneremail;
  }
  getpid() {
    return this._id;
  }

  getlocname() {
    return this._locName;
  }

  getaddress() {
    return this._address;
  }

  getcontact() {
    return this._contact;
  }

  getimagename() {
    return this._imagename;
  }

  getprice() {
    return this._price;
  }

  gettype() {
    return this._type;
  }

  getlat() {
    return this._lat;
  }

  getlon() {
    return this._lon;
  }

  getowner() {
    return this._owneremail;
  }
  setprice(price) {
    this._price = price;
  }
}
