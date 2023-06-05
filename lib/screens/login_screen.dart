// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/main_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var _isLogin = true;
  bool visible = true;
  final _form = GlobalKey<FormState>();
  var _enteredEmail = '';
  var _enteredPassword = '';
  var _enteredUsername = '';

  void _submit() {
    final isValid = _form.currentState!.validate();
    if (isValid) {
      _form.currentState!.save();
      Provider.of<AuthProvider>(context, listen: false).signInWithEmailAndPassword(_enteredEmail, _enteredPassword).then((value) {
        Provider.of<AuthProvider>(context, listen: false).isLogin ? Navigator.pushReplacementNamed(context, 'home') : print('failed');
      });
    }
  }

  void _submitRegister() {
    final isValid = _form.currentState!.validate();
    if (isValid) {
      _form.currentState!.save();
      Provider.of<AuthProvider>(context, listen: false).registerWithEmailAndPassword(_enteredEmail, _enteredPassword, _enteredUsername);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.indigo[400],
      // appBar: AppBar(
      //   title: const Text('Login'),
      // ),
      body: Form(
        key: _form,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 70, left: 70, right: 70),
                  child: Image.asset('assets/chat.png'),
                ),
                const SizedBox(
                  height: 20,
                ),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        !_isLogin
                            ? TextFormField(
                                decoration: const InputDecoration(
                                  label: Text('Username'),
                                ),
                                keyboardType: TextInputType.visiblePassword,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter a valid username';
                                  }
                                  return null;
                                },
                                onSaved: (newValue) {
                                  _enteredUsername = newValue!;
                                },
                              )
                            : Container(),
                        TextFormField(
                          decoration: const InputDecoration(
                            label: Text('Email address'),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          autocorrect: true,
                          textCapitalization: TextCapitalization.none,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty || !value.contains('@')) {
                              return 'Please enter a valid email address';
                            }
                            return null;
                          },
                          onSaved: (newValue) {
                            _enteredEmail = newValue!;
                          },
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                            label: const Text('Password'),
                            suffix: IconButton(
                              onPressed: () {
                                setState(() {
                                  visible = !visible;
                                });
                              },
                              icon: Icon(visible ? Icons.visibility : Icons.visibility_off),
                            ),
                          ),
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: visible,
                          validator: (value) {
                            if (value == null || value.trim().length < 6) {
                              return 'Please enter a valid email address';
                            }
                            return null;
                          },
                          onSaved: (newValue) {
                            _enteredPassword = newValue!;
                          },
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        ElevatedButton(
                          onPressed: _isLogin ? _submit : _submitRegister,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20, right: 20),
                            child: Text(_isLogin ? 'Login' : 'Sign Up'),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _isLogin = !_isLogin;
                            });
                          },
                          child: Text(_isLogin ? 'Create an account' : 'Already have an account'),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
