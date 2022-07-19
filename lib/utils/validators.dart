extension Validators on String {
  bool get isValidEmail {
    final emailRegExp =
        RegExp(r'^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$');

    return emailRegExp.hasMatch(this);
  }

  bool get isValidDni {
    final dniRegExp = RegExp(r'^[\d]{7,9}$');

    return dniRegExp.hasMatch(this);
  }

  bool get isValidPhoneNumber {
    final phoneNumberRegExp = RegExp(r'^[\d]{10}$');

    return phoneNumberRegExp.hasMatch(this);
  }

  bool get isValidDaysPack {
    final phoneNumberRegExp = RegExp(r'^[\d]{1,2}$');

    return phoneNumberRegExp.hasMatch(this);
  }

  bool get isValidPrice {
    final phoneNumberRegExp = RegExp(r'^\d+\.?\d*$');

    return phoneNumberRegExp.hasMatch(this);
  }

  bool get isValidUrl {
    const regex =
        r'https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)';
    final urlRegExp = RegExp(regex);

    return urlRegExp.hasMatch(this);
  }
}
