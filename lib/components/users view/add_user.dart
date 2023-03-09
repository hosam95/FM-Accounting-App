import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fm_accounting_app/components/users%20view/user_card.dart';
import 'package:fm_accounting_app/notifiers/organisation_notifier.dart';
import 'package:provider/provider.dart';

class AddUserCard extends StatefulWidget {
  const AddUserCard({super.key});

  @override
  State<AddUserCard> createState() => _AddUserCardState();
}

class _AddUserCardState extends State<AddUserCard> {
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
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(10, 30, 10, 10),
      child: Wrap(
        children: [
          Container(
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
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(5, 5, 5, 5),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Padding(
                          padding:
                              const EdgeInsetsDirectional.fromSTEB(5, 5, 5, 5),
                          child: TextFormField(
                            controller: textController,
                            obscureText: false,
                            decoration: InputDecoration(
                              labelText: 'Phone',
                              hintText: 'enter Phone',
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
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(5, 5, 5, 5),
                        child: ElevatedButton(
                          onPressed: () {
                            search();
                          },
                          style: ElevatedButton.styleFrom(
                              shape: const CircleBorder(),
                              backgroundColor:
                                  Color.fromARGB(255, 243, 192, 55)),
                          child: _isLoading
                              ? CircularProgressIndicator(
                                  color: Color.fromARGB(255, 95, 88, 88),
                                )
                              : const Icon(Icons.search),
                        ),
                      ),
                    ],
                  ),
                ),
                searchList(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget searchList() {
    if (textController!.text.isNotEmpty) {
      String oId = Provider.of<OrganisationNotifier>(context, listen: false)
          .organisation
          .id;

      return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("users")
            .doc("+2${textController!.text}")
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(5, 5, 5, 5),
              child: CircularProgressIndicator(
                color: Color.fromARGB(255, 95, 88, 88),
              ),
            );
          }

          if (!snapshot.data!.exists) {
            return const Text("no users found");
          }

          if ((snapshot.data!.get("oIds") as List).contains(oId)) {
            return Text("user is already added");
          }
          return UserCard(
            snapshot.data?.id as String,
            snapshot.data?.get("name") as String,
            true,
          );
        },
      );
    }

    return const SizedBox();
  }

  void search() async {
    setState(() {
      _errorMessage = "";
    });

    if (textController?.text == "") {
      _showError("Phone field is required");
      return;
    }
  }
}
