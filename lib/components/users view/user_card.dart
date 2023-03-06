import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fm_accounting_app/data/organisation.dart';
import 'package:fm_accounting_app/notifiers/organisation_notifier.dart';
import 'package:provider/provider.dart';

class UserCard extends StatefulWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String phone;
  final String name;
  final bool inSearch;
  final Function? onTap;

  UserCard(this.phone, this.name, this.inSearch, {this.onTap, super.key});

  @override
  State<UserCard> createState() =>
      _UserCardState(phone, name, inSearch, onTap: onTap);
}

class _UserCardState extends State<UserCard> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String phone;
  final String name;
  final bool inSearch;
  final Function? onTap;
  bool _isLoading = false;

  _UserCardState(this.phone, this.name, this.inSearch, {this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
      child: InkWell(
        onTap: () {
          onTap == null ? null : onTap!();
        },
        child: Container(
          width: double.infinity,
          height: 90,
          decoration: BoxDecoration(
            color: Color.fromARGB(200, 255, 255, 255),
            /*boxShadow: const [
              BoxShadow(
                blurRadius: 0,
                color: Color(0x33000000),
                offset: Offset(0, 2),
              )
            ],*/
            borderRadius: BorderRadius.circular(5),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
                child: Text(
                  phone,
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding:
                        const EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
                    child: Text(
                      name,
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      inSearch
                          ? addUserToOrganisation(context)
                          : updateUserAdminState(context);
                    },
                    style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        backgroundColor: isAdmin(context, phone: phone)
                            ? Colors.blue
                            : Colors.white),
                    child: _isLoading
                        ? CircularProgressIndicator(
                            color: Color.fromARGB(255, 95, 88, 88),
                          )
                        : Icon(inSearch ? Icons.add : Icons.vpn_key),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool isAdmin(context, {phone = ""}) {
    if (Provider.of<OrganisationNotifier>(context, listen: false)
        .organisation
        .admins
        .contains(phone)) {
      return true;
    }
    return false;
  }

  void addUserToOrganisation(context) {
    String oId = Provider.of<OrganisationNotifier>(context, listen: false)
        .organisation
        .id;
    _firestore.collection("users").doc(phone).update({
      "oIds": FieldValue.arrayUnion([oId])
    });
  }

  void updateUserAdminState(context) async {
    setState(() {
      _isLoading = true;
    });
    Organisation org =
        Provider.of<OrganisationNotifier>(context, listen: false).organisation;

    if (isAdmin(context, phone: phone)) {
      await _firestore.collection("organisations").doc(org.id).update({
        "admins": FieldValue.arrayRemove([phone])
      });
    } else {
      await _firestore.collection("organisations").doc(org.id).update({
        "admins": FieldValue.arrayUnion([phone])
      });
    }
    var updatedOrg =
        await _firestore.collection("organisations").doc(org.id).get();

    Provider.of<OrganisationNotifier>(context, listen: false).set(Organisation(
        id: updatedOrg.id,
        name: updatedOrg.get("name"),
        admins: updatedOrg.get("admins")));
    setState(() {
      _isLoading = false;
    });
  }
}
