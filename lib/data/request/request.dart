class LoginRequest {
  String email;
  String password;
  String imei;
  String deviceId;

  LoginRequest(this.email, this.password, this.imei, this.deviceId);
}

class RegisterRequest {
  String countryMobileCode;
  String password;
  String userName;
  String email;
  String mobileNumber;
  String profilePicture;

  RegisterRequest({
    required this.countryMobileCode,
    required this.password,
    required this.email,
    required this.mobileNumber,
    required this.profilePicture,
    required this.userName,
  });
}
