import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fm_accounting_app/notifiers/organisation_notifier.dart';
import 'package:provider/provider.dart';

class AddBussCard extends StatefulWidget {
  const AddBussCard({super.key});

  @override
  State<AddBussCard> createState() => _AddBussCardState();
}

class _AddBussCardState extends State<AddBussCard> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  TextEditingController? textController = TextEditingController();
  String _errorMessage = "";
  bool _isLoading = false;

  void _showError(String errorMessage) {
    setState(() {
      _errorMessage = errorMessage;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(10, 30, 10, 10),
      child: Container(
        width: double.infinity,
        height: 100,
        decoration: BoxDecoration(
          color: const Color(0xFFEFEBEB),
          boxShadow: const [
            BoxShadow(
              blurRadius: 4,
              color: Color(0x33000000),
              offset: Offset(0, 5),
            )
          ],
          borderRadius: BorderRadius.circular(5),
        ),
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(5, 5, 5, 5),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(5, 5, 5, 5),
                  child: TextFormField(
                    controller: textController,
                    obscureText: false,
                    decoration: InputDecoration(
                      labelText: 'IMEI',
                      hintText: 'enter Imei',
                      errorText: _errorMessage,
                      enabledBorder: UnderlineInputBorder(
                        borderSide: const BorderSide(
                          color: Color(0x00000000),
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: const BorderSide(
                          color: Color(0x00000000),
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      errorBorder: UnderlineInputBorder(
                        borderSide: const BorderSide(
                          color: Color(0x00000000),
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      focusedErrorBorder: UnderlineInputBorder(
                        borderSide: const BorderSide(
                          color: Color(0x00000000),
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      filled: true,
                      fillColor: const Color(0xFFFBF7F7),
                    ),
                    textAlign: TextAlign.start,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(5, 5, 5, 5),
                child: ElevatedButton(
                  onPressed: () {
                    addBus();
                  },
                  child: _isLoading
                      ? const CircularProgressIndicator(
                          color: Color.fromARGB(0, 0, 0, 0),
                          strokeWidth: 3,
                        )
                      : const Text('Add'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void addBus() async {
    setState(() {
      _isLoading = true;
      _errorMessage = "";
    });

    if (textController?.text == "") {
      _showError("Imei field is required");
      return;
    }

    String oId = Provider.of<OrganisationNotifier>(context, listen: false)
        .organisation
        .id;

    var bus = await _firestore
        .collection("buss")
        .where("imei", isEqualTo: textController!.text)
        .where("oId", isEqualTo: oId)
        .get();

    if (bus.size != 0) {
      _showError("Bus already exists");
      return;
    }

    await _firestore
        .collection("buss")
        .doc()
        .set({"imei": textController!.text, "oId": oId});

    textController?.clear();
    setState(() {
      _isLoading = false;
    });
  }
}
