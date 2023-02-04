//write a flutter registration page that takes a phone number and name then folow the coresponding logic:
//check if the phone number is regestered in firebase auth, if so return to login page
//else register it to firebase auth and get an OTP ,and whene the OTP is valedated correctly save a record to firestore that carrys 4 null values.
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String _phoneNumber = "";
  String _name = "";
  String _verificationId = "";
  String _errorMessage = "";
  bool _isLoading = false;

  void _showError(String errorMessage) {
    setState(() {
      _errorMessage = errorMessage;
      _isLoading = false;
    });
  }

  Future<void> _verifyPhoneNumber() async {
    setState(() {
      _errorMessage = "";
      _isLoading = true;
    });

    var acc = await _firestore.collection("users").doc(_phoneNumber).get();
    if (!acc.exists) {
      setState(() {
        _errorMessage = 'account not found \ntry to register first.';
        _isLoading = false;
      });
      return;
    }

    final PhoneVerificationCompleted verificationCompleted =
        (AuthCredential phoneAuthCredential) {
      _auth.signInWithCredential(phoneAuthCredential).then((result) {
        context.go("/");
      }).catchError((error) {
        _showError(error.message);
      });
    };

    // ignore: prefer_function_declarations_over_variables
    final PhoneVerificationFailed verificationFailed =
        (FirebaseAuthException exception) {
      // ignore: prefer_if_null_operators
      _showError(exception.message != null
          ? exception.message.toString()
          : "unknowen error");
    };

    final PhoneCodeSent codeSent =
        (String verificationId, int? forceResendingToken) {
      _verificationId = verificationId;
      setState(() {
        _isLoading = false;
      });
    };

    final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationId) {
      _verificationId = verificationId;
    };

    await _auth.verifyPhoneNumber(
        phoneNumber: _phoneNumber,
        timeout: const Duration(seconds: 60),
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
  }

  Widget _buildPhoneNumberField() {
    return TextField(
      decoration: InputDecoration(
        hintText: "Phone number (e.g. 01234567890)",
        errorText: _errorMessage,
      ),
      keyboardType: TextInputType.phone,
      onChanged: (value) => _phoneNumber = "+2" + value,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Log In"),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _buildPhoneNumberField(),
            SizedBox(height: 16),
            _isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    child: Text("Verify"),
                    onPressed: () async {
                      _verifyPhoneNumber();
                    },
                  ),
            SizedBox(height: 16),
            GestureDetector(
              onTap: () {
                context.go("/register");
              },
              child: new Text("Sign up?"),
            ),
          ],
        ),
      ),
    );
  }
}
