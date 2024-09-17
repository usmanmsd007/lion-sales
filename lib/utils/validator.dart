emailValidate(value) {
  String pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

  if (value.isEmpty) {
    return "Enter Email Address";
  } else if (!RegExp(pattern).hasMatch(value)) {
    return "Invalid Email Address";
  }
  return null;
}

passwordValidate(value) {
  if (value.trim().isEmpty) {
    return "Enter password";
  } else if (value.trim().length < 8) {
    return "Password is less then 8 character";
  } else {
    return null;
  }
}

firstNameValidate(String value) {
  if (value.isEmpty) {
    return "Enter first name";
  }
  if (value.contains('@')) {
    return "Invalid name";
  }
  return null;
}

lastNameValidate(value) {
  if (value.isEmpty) {
    return "Enter last name";
  }
  if (value.contains('@')) {
    return "Invalid name";
  }
  return null;
}

/*
import '../main.dart';
// import '../utils/payment_card.dart';

validateEmptyField(String value, String message) {
  if ((value.trim()).isEmpty) {
    return message;
  } else {
    return "";
  }
}

validateCardNumber(value) {
  String? validateCardNum = CardUtils().validateCardNum(value);
  if (validateCardNum != null) {
    return validateCardNum;
  } else {
    return "";
  }
}

validateExpirationDate(value) {
  String? validateCardDate = CardUtils().validateDate(value);
  if (validateCardDate != null) {
    return validateCardDate;
  } else {
    return "";
  }
}

validateWithFixLength(
    String value, int length, String emptyMsg, String invalidMsg) {
  if (value.trim().isEmpty) {
    return emptyMsg;
  } else if (value.trim().length != length) {
    return invalidMsg;
  } else {
    return "";
  }
}



validateOldPassword(String value) {
  if (value.trim().isEmpty) {
    return languages.enterOldPass;
  } else if (value.trim().length < 6) {
    return languages.passShortMsg;
  } else {
    return "";
  }
}

validateNewPassword(String value) {
  if (value.trim().isEmpty) {
    return languages.enterNewPass;
  } else if (value.trim().length < 6) {
    return languages.passShortMsg;
  } else {
    return "";
  }
}

validateConfPassword(String value, String newPass) {
  if (value.trim().isEmpty) {
    return languages.enterConfPass;
  } else if (0 != newPass.trim().compareTo(value)) {
    return languages.confPassNotMatchWithNew;
  } else {
    return "";
  }
}

fullNameValidate(value) {
  if (value.isEmpty) {
    return languages.enterFullName;
  }
  return "";
}



mobileNumberValidate(value) {
  if (value.isEmpty) {
    return languages.enterMobileNumber;
  }
  return "";
}

confirmPasswordValidate(value, compareValue) {
  if (value.isEmpty) {
    return languages.enterConfPass;
  } else if (value != compareValue) {
    return languages.confPassNotMatch;
  }
  return "";
}



String emailValidateOptional(value) {
  String pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

  if (value.isNotEmpty && !RegExp(pattern).hasMatch(value)) {
    return languages.invalidEmailAddress;
  }
  return "";
}

validateCourierGoods(
    dynamic value, double goodsItem, String emptyMsg, String invalidMsg) {
  if (value.trim().isEmpty) {
    return emptyMsg;
  } else if (value.trim().isNotEmpty &&
      double.parse(value.trim()) > goodsItem) {
    return invalidMsg;
  }
  return "";
}
*/
