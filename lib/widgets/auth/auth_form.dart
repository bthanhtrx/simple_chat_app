import 'dart:io';

import 'package:flutter/material.dart';
import 'package:simple_chat_app/widgets/pickers/user_image_picker.dart';

class AuthForm extends StatefulWidget {
  final void Function(String email, String username, String password,
      bool isLogin, BuildContext ctx) submitForm;

  final bool isLoading;

  AuthForm(this.submitForm, this.isLoading);

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _form = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _userNameController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _passwordVisibility = true;

  late String _email = '';
  late String _userName = '';
  late String _password = '';

  bool isLogin = true;

  File? _pickedImage;

  @override
  void dispose() {
    _emailController.dispose();
    _userNameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_form.currentState!.validate()) {
      print('Submit: ${_emailController.text}');
      print('Submit: ${_password}');

      widget.submitForm(_emailController.text, _userNameController.text,
          _passwordController.text, isLogin, context);
    }
    FocusScope.of(context).unfocus();
  }

  void _pickedImageFn(File? pickedImage) {
    _pickedImage = pickedImage;
    print('picked Image: ${_pickedImage?.path}');
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _form,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // if (!isLogin) UserImagePicker(_pickedImageFn),
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    decoration:
                        const InputDecoration(labelText: 'Email Address'),
                    controller: _emailController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Required Field';
                      }
                      if (!value.contains(RegExp(r'.*@[a-z]{2,}\.[a-z]{2,}'))) {
                        return 'Not A valid Email Address';
                      }
                      return null;
                    },
                    // onSaved: (newValue) {
                    //   _email = newValue!;
                    // },
                  ),
                  if (!isLogin)
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Username'),
                      controller: _userNameController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Required Field';
                        }
                        if (value!.length < 5) {
                          return 'Username Too Short';
                        }
                        return null;
                      },
                      // onSaved: (newValue) {
                      //   _userName = newValue!;
                      // },
                    ),
                  TextFormField(
                    keyboardType: TextInputType.text,
                    obscureText: _passwordVisibility,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      suffixIcon: IconButton(
                        icon: Icon(Icons.visibility),
                        onPressed: () {
                          setState(() {
                            _passwordVisibility = !_passwordVisibility;
                          });
                        },
                      ),
                    ),
                    controller: _passwordController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Required Field';
                      }
                      if (value.length < 5) {
                        return 'Password Too Short';
                      }

                      return null;
                    },
                    // onSaved: (newValue) {
                    //   _password = newValue!;
                    // },
                  ),
                  isLogin
                      ? const SizedBox.shrink()
                      : TextFormField(
                          keyboardType: TextInputType.text,
                          obscureText: true,
                          decoration: const InputDecoration(
                              labelText: 'Re-Enter Password'),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Required Field';
                            }
                            if (value != _passwordController.text) {
                              return 'Password Not Match';
                            }

                            return null;
                          },
                        ),
                  const SizedBox(
                    height: 12,
                  ),
                  widget.isLoading
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: () {
                            _submitForm();
                          },
                          child: Text(isLogin ? 'Login' : 'Sign Up'),
                        ),
                  if (!widget.isLoading)
                    TextButton(
                      onPressed: () {
                        setState(() {
                          isLogin = !isLogin;
                        });
                      },
                      child: Text(
                          isLogin ? 'Create New Account' : 'Login Instead'),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
