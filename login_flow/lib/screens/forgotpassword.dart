import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:login_flow/classes/verify_cred.dart';
import 'package:provider/provider.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  static const route = '/forgotpass';

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController userController = TextEditingController();

  Future<void> send() async {
    final Email email = Email(
      body: 'Spero funzioni',
      subject: 'Recover your password',
      recipients: [userController.text],
      isHTML: false,
    );

    String platformResponse;

    try {
      await FlutterEmailSender.send(email);
      platformResponse = 'success';
    } catch (error) {
      print(error);
      platformResponse = error.toString();
    }

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(platformResponse),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Recover Password')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: const Text(
                'Recover your password',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              child: TextFormField(
                controller: userController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  icon: Icon(Icons.person),
                  labelText: 'Username *',
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: const Text(
                'An e-mail with your old password will be sent to your e-mail adress',
                style: TextStyle(fontSize: 15),
              ),
            ),
            Consumer<VerifyCredentials>(
              builder: (context, verifyCred, child) => ElevatedButton(
                  child: const Text('Send e-mail'),
                  onPressed: () {
                    if (!userController.text.contains('@')) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Insert a valid e-mail'),
                        backgroundColor: Colors.red,
                      ));
                    } else {
                      send();
                    }
                  }),
            )
          ],
        ),
      ),
    );
  }
}

