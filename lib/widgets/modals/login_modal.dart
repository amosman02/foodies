import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:foodies/constants/colors.dart' as constants;
import 'package:foodies/services/auth_service.dart';
import 'package:foodies/widgets/custom_text_field.dart';

final _firebase = FirebaseAuth.instance;

class LoginModal extends StatefulWidget {
  const LoginModal({super.key});

  @override
  State<LoginModal> createState() => _LoginModalState();
}

class _LoginModalState extends State<LoginModal> {
  final _formKey = GlobalKey<FormState>();
  var _enteredEmail = '';
  var _enteredPassword = '';
  var isLoading = false;

  void _submit() async {
    final isValid = _formKey.currentState!.validate();

    if (!isValid) {
      return;
    }

    _formKey.currentState!.save();

    try {
      isLoading = true;
      await _firebase.signInWithEmailAndPassword(
          email: _enteredEmail, password: _enteredPassword);
      if (!mounted) return;
      Navigator.of(context).pop();
      isLoading = false;
    } on FirebaseAuthException catch (error) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error.message ?? 'Authentication failed!')));
      isLoading = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    const String googleSvg = '''
    <svg version="1.1" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 48 48" xmlns:xlink="http://www.w3.org/1999/xlink" style="display: block;">
        <path fill="#EA4335" d="M24 9.5c3.54 0 6.71 1.22 9.21 3.6l6.85-6.85C35.9 2.38 30.47 0 24 0 14.62 0 6.51 5.38 2.56 13.22l7.98 6.19C12.43 13.72 17.74 9.5 24 9.5z"></path>
        <path fill="#4285F4" d="M46.98 24.55c0-1.57-.15-3.09-.38-4.55H24v9.02h12.94c-.58 2.96-2.26 5.48-4.78 7.18l7.73 6c4.51-4.18 7.09-10.36 7.09-17.65z"></path>
        <path fill="#FBBC05" d="M10.53 28.59c-.48-1.45-.76-2.99-.76-4.59s.27-3.14.76-4.59l-7.98-6.19C.92 16.46 0 20.12 0 24c0 3.88.92 7.54 2.56 10.78l7.97-6.19z"></path>
        <path fill="#34A853" d="M24 48c6.48 0 11.93-2.13 15.89-5.81l-7.73-6c-2.15 1.45-4.92 2.3-8.16 2.3-6.26 0-11.57-4.22-13.47-9.91l-7.98 6.19C6.51 42.62 14.62 48 24 48z"></path>
        <path fill="none" d="M0 0h48v48H0z"></path>
    </svg>
    ''';

    return Wrap(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 85 / 100,
          padding:
              const EdgeInsets.only(left: 16, right: 16, bottom: 32, top: 16),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: ListView(
            shrinkWrap: true,
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            physics: const BouncingScrollPhysics(),
            children: [
              Align(
                alignment: Alignment.center,
                child: Container(
                  width: MediaQuery.of(context).size.width * 35 / 100,
                  margin: const EdgeInsets.only(bottom: 20),
                  height: 6,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              // header
              Container(
                margin: const EdgeInsets.only(bottom: 24),
                child: const Text(
                  'Login',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'inter'),
                ),
              ),
              // Form
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    CustomTextField(
                      title: 'Email',
                      hint: 'youremail@email.com',
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Email address is required';
                        }
                        if (!value.contains("@")) {
                          return 'Enter a valid email address';
                        }
                        return null;
                      },
                      onSaved: (value) =>
                          setState(() => _enteredEmail = value!),
                    ),
                    CustomTextField(
                      title: 'Password',
                      hint: '**********',
                      obsecureText: true,
                      margin: const EdgeInsets.only(top: 16),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Password is required';
                        }
                        return null;
                      },
                      onSaved: (value) =>
                          setState(() => _enteredPassword = value!),
                    ),
                    // Log in Button
                    Container(
                      margin: const EdgeInsets.only(top: 32, bottom: 6),
                      width: MediaQuery.of(context).size.width,
                      height: 60,
                      child: ElevatedButton(
                        onPressed: _submit,
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          backgroundColor: constants.primaryColor,
                        ),
                        child: isLoading
                            ? const CircularProgressIndicator(
                                color: constants.bgColor,
                              )
                            : const Text(
                                'Login',
                                style: TextStyle(
                                  color: constants.bgColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 50),
              Row(
                children: <Widget>[
                  const Expanded(child: Divider()),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    child: const Text("OR"),
                  ),
                  const Expanded(child: Divider()),
                ],
              ),
              const SizedBox(height: 40),
              SizedBox(
                height: 60,
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton.icon(
                  onPressed: () => AuthService().signInWithGoogle(context),
                  label: const Text(
                    'Login with Google',
                    style: TextStyle(
                      color: constants.bgColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  icon: SvgPicture.string(
                    googleSvg,
                    width: 20,
                  ),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    backgroundColor: constants.primaryColor,
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
