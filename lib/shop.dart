class Shop {
  String _pid;
  String _locName;
  double _price;
  String _type;
  String _contact;
  String _address;
  String _imagename;

  Shop(
    String pid,
    String locName,
    double price,
    String type,
    String contact,
    String address,
    String imagename,
  ) {
    this._pid = pid;
    this._locName = locName;
    this._price = price;
    this._type = type;
    this._contact = contact;
    this._address = address;
    this._imagename = imagename;
  }
  getpid() {
    return this._pid;
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
}
