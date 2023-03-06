import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fm_accounting_app/notifiers/organisation_notifier.dart';
import 'package:provider/provider.dart';

class AddDriversCard extends StatefulWidget {
  const AddDriversCard({super.key});

  @override
  State<AddDriversCard> createState() => _AddDriversCardState();
}

class _AddDriversCardState extends State<AddDriversCard> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  TextEditingController? idController = TextEditingController();
  TextEditingController? nameController = TextEditingController();
  String _idErrorMessage = "";
  String _nameErrorMessage = "";
  bool _isLoading = false;

  void _showError(String errorMessage) {
    setState(() {
      _idErrorMessage = errorMessage;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(10, 30, 10, 10),
      child: Container(
        width: double.infinity,
        height: 230,
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
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(5, 10, 5, 0),
                child: TextFormField(
                  controller: idController,
                  obscureText: false,
                  decoration: InputDecoration(
                    labelText: 'Id',
                    hintText: 'enter the driver Id',
                    errorText: _idErrorMessage,
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
            Expanded(
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(5, 0, 5, 0),
                child: TextFormField(
                  controller: nameController,
                  obscureText: false,
                  decoration: InputDecoration(
                    labelText: 'name',
                    hintText: 'enter the driver name',
                    errorText: _nameErrorMessage,
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
              padding: const EdgeInsetsDirectional.fromSTEB(5, 0, 5, 0),
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
    );
  }

  void addBus() async {
    print("start: ");
    setState(() {
      _isLoading = true;
      _idErrorMessage = "";
      _nameErrorMessage = "";
    });

    if (idController?.text == "") {
      setState(() {
        _isLoading = false;
        _idErrorMessage = "Id field is required";
        _nameErrorMessage = "";
      });
      return;
    }

    if (nameController?.text == "") {
      setState(() {
        _isLoading = false;
        _idErrorMessage = "";
        _nameErrorMessage = "name field is required";
      });
      return;
    }

    String oId = Provider.of<OrganisationNotifier>(context, listen: false)
        .organisation
        .id;

    var bus = await _firestore
        .collection("drivers")
        .where("id", isEqualTo: idController!.text)
        .where("oId", isEqualTo: oId)
        .get();

    print(bus.docs);

    if (bus.size != 0) {
      setState(() {
        _isLoading = false;
        _idErrorMessage = "driver already exists";
        _nameErrorMessage = "";
      });
      return;
    }

    await _firestore.collection("drivers").doc().set({
      "id": idController!.text,
      "name": nameController!.text,
      "oId": oId,
      "bId": ""
    });

    idController?.clear();
    nameController?.clear();
    setState(() {
      _isLoading = false;
      _idErrorMessage = "";
      _nameErrorMessage = "";
    });
  }
}
