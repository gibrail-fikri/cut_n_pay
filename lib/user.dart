class User {
  String _name, _email, _phone, _password;

  User(
    String name,
    email,
    phone,
    password,
  ) {
    this._name = name;
    this._email = email;
    this._password = password;
    this._phone = phone;
  }

  getname() {
    return this._name;
  }

  getemail() {
    return this._email;
  }

  getpass() {
    return this._password;
  }

  getphone() {
    return this._phone;
  }

  setname(name) {
    this._name = name;
  }

  setphone(phone) {
    this._phone = phone;
  }
}
