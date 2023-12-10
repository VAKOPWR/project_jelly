import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:project_jelly/logic/auth.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  Map userData = {};
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final RoundedLoadingButtonController _registerBtnController =
      RoundedLoadingButtonController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isEmailInUse = false;

  void _submitForm() async {
    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      bool registrationSuccess = await apiRegister(
          _nameController.text,
          _phoneController.text,
          _emailController.text,
          _passwordController.text);

      if (!registrationSuccess) {
        _registerBtnController.error();
        setState(() {
          _isEmailInUse = true;
        });
      } else {
        _registerBtnController.success();
        Get.offNamedUntil('/register_avatar', (route) => false);
      }
    } else {
      _registerBtnController.error();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          leading: null,
          title: const Text('Register '),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: _nameController,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: MultiValidator([
                          RequiredValidator(errorText: 'Enter your name'),
                          MinLengthValidator(3,
                              errorText: 'Minimum 3 charecter filled name'),
                        ]),
                        onChanged: (value) {
                          if (!_isEmailInUse) {
                            _registerBtnController.reset();
                          }
                        },
                        decoration: InputDecoration(
                            hintText: 'Name',
                            labelText: 'Name',
                            prefixIcon: Icon(
                              Icons.person,
                              color: Colors.grey,
                            ),
                            errorStyle: TextStyle(fontSize: 14.0),
                            border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context).colorScheme.error),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(9.0)))),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: _emailController,
                        validator: MultiValidator([
                          RequiredValidator(errorText: 'Enter email address'),
                          EmailValidator(
                              errorText: 'Enter valid email address'),
                        ]),
                        onChanged: (value) {
                          setState(() {
                            _isEmailInUse = false;
                            _registerBtnController.reset();
                          });
                        },
                        decoration: InputDecoration(
                            hintText: 'example@example.com',
                            errorText: _isEmailInUse
                                ? 'Email address is already registered'
                                : null,
                            labelText: 'Email',
                            prefixIcon: const Icon(
                              Icons.email,
                              color: Colors.grey,
                            ),
                            errorStyle: const TextStyle(fontSize: 14.0),
                            border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context).colorScheme.error),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(9.0)))),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: _phoneController,
                        validator: MultiValidator([
                          RequiredValidator(errorText: 'Enter phone number'),
                          PatternValidator(
                              r'^[\+]?[(]?[0-9]{3}[)]?[-\s\.]?[0-9]{3}[-\s\.]?[0-9]{4,6}$',
                              errorText: 'Enter valid phone number'),
                        ]),
                        onChanged: (value) {
                          if (!_isEmailInUse) {
                            _registerBtnController.reset();
                          }
                        },
                        decoration: InputDecoration(
                            hintText: '+1 (555) 555-1234',
                            labelText: 'Phone number',
                            prefixIcon: Icon(
                              Icons.phone,
                              color: Colors.grey,
                            ),
                            errorStyle: TextStyle(fontSize: 14.0),
                            border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context).colorScheme.error),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(9.0)))),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        obscureText: _obscurePassword,
                        controller: _passwordController,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: MultiValidator([
                          RequiredValidator(errorText: 'Password is required'),
                          MinLengthValidator(6,
                              errorText:
                                  'Password must be at least 6 characters long'),
                        ]),
                        onChanged: (value) {
                          if (!_isEmailInUse) {
                            _registerBtnController.reset();
                          }
                        },
                        decoration: InputDecoration(
                            hintText: 'Password',
                            labelText: 'Password',
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                            prefixIcon: const Icon(
                              Icons.key,
                              color: Colors.grey,
                            ),
                            errorStyle: const TextStyle(fontSize: 14.0),
                            border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context).colorScheme.error),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(9.0)))),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        obscureText: _obscureConfirmPassword,
                        controller: _confirmPasswordController,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          if (value != _passwordController.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          if (!_isEmailInUse) {
                            _registerBtnController.reset();
                          }
                        },
                        decoration: InputDecoration(
                            hintText: 'Password Confirmation',
                            labelText: 'Password Confirmation',
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscureConfirmPassword
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscureConfirmPassword =
                                      !_obscureConfirmPassword;
                                });
                              },
                            ),
                            prefixIcon: const Icon(
                              Icons.key,
                              color: Colors.grey,
                            ),
                            errorStyle: const TextStyle(fontSize: 14.0),
                            border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context).colorScheme.error),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(9.0)))),
                      ),
                    ),
                    Center(
                        child: Padding(
                            padding: const EdgeInsets.all(28.0),
                            child: SizedBox(
                                width: MediaQuery.of(context).size.width,
                                height: 50,
                                child: RoundedLoadingButton(
                                  controller: _registerBtnController,
                                  onPressed: _submitForm,
                                  color: Theme.of(context).colorScheme.primary,
                                  child: const Text(
                                    'Sign Up',
                                    style: TextStyle(fontSize: 22),
                                  ),
                                )))),
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: Center(
                          child: Text(
                            'Or Sign Up Using',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                          child: Row(
                            children: [
                              SizedBox(
                                height: 50,
                                width: 50,
                                child: Image.asset(
                                  'assets/google.png',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                )),
          ),
        ));
  }
}
