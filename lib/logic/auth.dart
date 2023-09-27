import 'package:flutter/material.dart';

Future<String?> apiLogIn(String email, String password) async {
  await Future.delayed(const Duration(seconds: 2));
  if (email == 'root@r.c') {
    if (password == 'root') {
      return 'ApiKey';
    }
  }
  return null;
}

Future<bool> apiRegister(
    String name, String phone, String email, String password) async {
  await Future.delayed(const Duration(seconds: 2));
  if (email == 'root@r.c') {
    return false;
  }
  return true;
}

Future<bool> apiSendResetPasswordCode(String email) async {
  await Future.delayed(const Duration(seconds: 2));
  return true;
}

Future<bool> apiVerifyResetPasswordCode(String email, String code) async {
  await Future.delayed(const Duration(seconds: 2));
  if (code == '1122') {
    return true;
  }
  return false;
}

Future<bool> apiResetPassword(String email, String newPassword) async {
  await Future.delayed(const Duration(seconds: 2));
  return true;
}

Future<bool> apiSetProfileImage(String apiKey, FileImage profileImage) async {
  await Future.delayed(const Duration(seconds: 2));
  return true;
}

Future<bool> apiLogOut(String apiKey) async {
  await Future.delayed(const Duration(seconds: 2));
  return true;
}
