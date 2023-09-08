import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:project_jelly/logic/auth.dart';
import 'package:project_jelly/pages/Auth/register_form.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class LogInPage extends StatefulWidget {
  const LogInPage({Key? key}) : super(key: key);

  @override
  State<LogInPage> createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final RoundedLoadingButtonController _submitBtnController =
      RoundedLoadingButtonController();

  bool _obscurePassword = true;
  bool _isEmailValid = true;
  bool _isPasswordValid = true;

  void _submitForm() async {
    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      bool logInSuccess =
          await apiLogIn(_emailController.text, _passwordController.text);

      if (!logInSuccess) {
        _submitBtnController.error();
        setState(() {
          _isEmailValid = false;
          _isPasswordValid = false;
        });
      } else {
        _submitBtnController.success();
        Get.offNamed('/map');
      }
    } else {
      _submitBtnController.error();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Log In'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 30.0),
              child: Center(
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      border: Border.all(color: Colors.blueGrey)),
                  child: Image.asset('assets/logo.jpg'),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: TextFormField(
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  validator: MultiValidator([
                                    RequiredValidator(
                                        errorText: 'Enter email address'),
                                    EmailValidator(
                                        errorText: 'Enter valid email address'),
                                  ]),
                                  onChanged: (value) {
                                    setState(() {
                                      _isEmailValid = true;
                                      _isPasswordValid = true;
                                      _submitBtnController.reset();
                                    });
                                  },
                                  controller: _emailController,
                                  decoration: InputDecoration(
                                      hintText: 'Email',
                                      labelText: 'Email',
                                      errorText: _isEmailValid
                                          ? null
                                          : 'Email is not valid',
                                      prefixIcon: const Icon(
                                        Icons.email,
                                        color: Colors.blue,
                                      ),
                                      // errorStyle: _isLogInFail
                                      //     ? const TextStyle(fontSize: 0.0)
                                      //     : const TextStyle(fontSize: 14.0),
                                      errorStyle:
                                          const TextStyle(fontSize: 14.0),
                                      border: const OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.red),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(9.0)))))),
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: TextFormField(
                              obscureText: _obscurePassword,
                              validator: MultiValidator([
                                RequiredValidator(
                                    errorText: 'Please enter Password'),
                              ]),
                              onChanged: (value) {
                                setState(() {
                                  _isPasswordValid = true;
                                  _submitBtnController.reset();
                                });
                              },
                              controller: _passwordController,
                              decoration: InputDecoration(
                                hintText: 'Password',
                                labelText: 'Password',
                                errorText: _isPasswordValid
                                    ? null
                                    : 'Password is not valid',
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
                                  color: Colors.green,
                                ),
                                errorStyle: const TextStyle(fontSize: 14.0),
                                border: const OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(9.0))),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Get.toNamed('/forgotPass');
                            },
                            child: Container(
                              margin: const EdgeInsets.fromLTRB(180, 0, 0, 0),
                              child: const Text(
                                'Forgot Password?',
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(28.0),
                            child: SizedBox(
                                width: MediaQuery.of(context).size.width,
                                height: 50,
                                child: RoundedLoadingButton(
                                  controller: _submitBtnController,
                                  onPressed: _submitForm,
                                  color: Colors.blue,
                                  child: const Text(
                                    'Log In',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 22),
                                  ),
                                )
                                // child: ElevatedButton(
                                //     onPressed: _submitForm,
                                //     style: ElevatedButton.styleFrom(
                                //         backgroundColor: Colors.blue,
                                //         shape: RoundedRectangleBorder(
                                //             borderRadius:
                                //                 BorderRadius.circular(30))),
                                //     child: const Text(
                                //       'Log In',
                                //       style: TextStyle(
                                //           color: Colors.white, fontSize: 22),
                                //     )),
                                ),
                          ),
                          const Center(
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
                              child: Center(
                                child: Text(
                                  'Or Sign In Using!',
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.black),
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
                                        'assets/google.svg',
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          GestureDetector(
                            onTap: () {
                              // Get.toNamed('/signup');
                              Get.to(() => const RegisterPage(),
                                  transition: Transition.downToUp,
                                  duration: const Duration(seconds: 1));
                              // Get.offNamed('/register');
                            },
                            child: Center(
                              child: Container(
                                padding: const EdgeInsets.only(top: 50),
                                child: const Text(
                                  'REGISTER',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                      color:
                                          Colors.lightBlue // Add an underline
                                      ),
                                ),
                              ),
                            ),
                          ),
                        ]),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
