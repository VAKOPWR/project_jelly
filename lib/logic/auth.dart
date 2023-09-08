Future<bool> apiLogIn(String email, String password) async {
  await Future.delayed(const Duration(seconds: 2));

  return true;
}

Future<bool> apiRegister(
    String name, String phone, String email, String password) async {
  await Future.delayed(const Duration(seconds: 2));
  print(name);
  print(phone);
  print(email);
  print(password);
  return true;
}

Future<bool> apiSendResetPasswordCode(String email) async {
  await Future.delayed(const Duration(seconds: 2));
  print(email);
  return true;
}

Future<bool> apiVerifyResetPasswordCode(String email, String code) async {
  await Future.delayed(const Duration(seconds: 2));
  print(email);
  print(code);
  return true;
}

Future<bool> apiResetPassword(String email, String newPassword) async {
  await Future.delayed(const Duration(seconds: 2));
  print(email);
  print(newPassword);
  return true;
}
