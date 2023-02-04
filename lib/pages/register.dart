//write a flutter registration page that takes a phone number and name then folow the coresponding logic:
//check if the phone number is regestered in firebase auth, if so return to login page
//else register it to firebase auth and get an OTP ,and whene the OTP is valedated correctly save a record to firestore that carrys 4 null values.
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
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
    if (_name == "") {
      setState(() {
        _errorMessage = "name field is required";
        _isLoading = false;
      });
      return;
    }

    setState(() {
      _errorMessage = "";
      _isLoading = true;
    });

    final PhoneVerificationCompleted verificationCompleted =
        (AuthCredential phoneAuthCredential) {
      _auth.signInWithCredential(phoneAuthCredential).then((result) {
        _firestore
            .collection("users")
            .doc(_phoneNumber)
            .set({"uid": result.user!.uid, "name": _name, "oIds": []});
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

  Widget _buildNameField() {
    return TextField(
      decoration: InputDecoration(
        hintText: "Name",
      ),
      onChanged: (value) => _name = value,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Register"),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _buildPhoneNumberField(),
            SizedBox(height: 16),
            _buildNameField(),
            SizedBox(height: 16),
            _isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    child: Text("Sign Up"),
                    onPressed: () async {
                      _verifyPhoneNumber();
                    },
                  ),
            SizedBox(height: 16),
            GestureDetector(
              onTap: () {
                context.go("/login");
              },
              child: new Text("Sign in?"),
            ),
          ],
        ),
      ),
    );
  }
}
