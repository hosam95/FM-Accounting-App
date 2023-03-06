import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fm_accounting_app/components/buss%20view/bus_card.dart';
import 'package:fm_accounting_app/components/drivers%20view/driver_card.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../data/bus.dart';
import '../../data/driver.dart';
import '../../notifiers/organisation_notifier.dart';

class SearchPage extends StatefulWidget {
  final String? type;
  final String? selectedId;
  const SearchPage({super.key, this.type, this.selectedId});

  @override
  State<SearchPage> createState() => _SearchPageState(type, selectedId);
}

class _SearchPageState extends State<SearchPage> {
  final String? type;
  final String? selectedId;
  bool? _isDriver;
  _SearchPageState(this.type, this.selectedId);

  @override
  void initState() {
    this._isDriver = type == "driver";
    super.initState();
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  TextEditingController? textController = TextEditingController();
  String _errorMessage = "";
  bool _isLoading = false;

  void _showError(String errorMessage) {
    setState(() {
      _errorMessage = errorMessage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(10, 30, 10, 10),
            child: Container(
              width: double.infinity,
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
                  TextFormField(
                    controller: textController,
                    obscureText: false,
                    decoration: InputDecoration(
                      labelText: _isDriver! ? 'Id' : 'Imei',
                      hintText: _isDriver! ? 'enter Id' : 'enter Imai',
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
                    onChanged: (value) {
                      setState(() {});
                    },
                  ),
                  searchList(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget searchList() {
    String oId = Provider.of<OrganisationNotifier>(context, listen: false)
        .organisation
        .id;

    return StreamBuilder(
      stream: _firestore
          .collection(_isDriver! ? "drivers" : "buss")
          .where("oId", isEqualTo: oId)
          /*.where(_isDriver! ? 'id' : 'imei',
              isGreaterThanOrEqualTo: textController!.text)
          .where(_isDriver! ? 'id' : 'imei',
              isLessThan: textController!.text + 'z')*/
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Padding(
            padding: EdgeInsetsDirectional.fromSTEB(5, 5, 5, 5),
            child: CircularProgressIndicator(
              color: Color.fromARGB(255, 95, 88, 88),
            ),
          );
        }

        if (snapshot.data!.docs.isEmpty) {
          return const Text("no results found");
        }

        return SizedBox(
          height: 640,
          child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemCount: snapshot.data?.docs.length,
              itemBuilder: (context, index) {
                if (!(snapshot.data?.docs[index].get(_isDriver! ? 'id' : 'imei')
                        as String)
                    .startsWith(textController?.text as Pattern)) {
                  return const SizedBox();
                }
                return _isDriver!
                    ? DriverCard(
                        (snapshot.data?.docs[index].get("id") as String),
                        snapshot.data?.docs[index].get("name") as String,
                        onTap: "update driver and pop",
                        isSelected:
                            Provider.of<Driver>(context, listen: false).id ==
                                snapshot.data?.docs[index].get("id") as String,
                      )
                    : BusCard(
                        snapshot.data?.docs[index].get("imei") as String,
                        id: snapshot.data?.docs[index].id as String,
                        onTap: "update bus and pop",
                        isSelected:
                            Provider.of<Bus>(context, listen: false).id ==
                                snapshot.data?.docs[index].id as String,
                      );
              }),
        );
      },
    );
  }
}
