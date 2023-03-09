import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fm_accounting_app/notifiers/organisation_notifier.dart';
import 'package:provider/provider.dart';

import 'add_driver.dart';
import 'driver_card.dart';

class DriversView extends StatefulWidget {
  const DriversView({super.key});

  @override
  State<DriversView> createState() => _DriversViewState();
}

class _DriversViewState extends State<DriversView> {
  TextEditingController? textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.90,
        child: Column(
          children: [
            const AddDriversCard(),
            Expanded(
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
                child: Container(
                  width: double.infinity,
                  height: 100,
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(176, 239, 235, 235),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 4,
                        color: Color(0x33000000),
                        offset: Offset(0, 5),
                      )
                    ],
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(0),
                      bottomRight: Radius.circular(0),
                      topLeft: Radius.circular(5),
                      topRight: Radius.circular(5),
                    ),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(5, 5, 5, 5),
                        child: TextFormField(
                          controller: textController,
                          decoration: InputDecoration(
                            labelText: 'Id',
                            hintText: 'enter Id',
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
                            filled: true,
                            fillColor: const Color(0xFFFBF7F7),
                          ),
                          textAlign: TextAlign.start,
                          onChanged: (value) {
                            setState(() {});
                          },
                        ),
                      ),
                      driversList(),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget driversList() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("drivers")
          .where("oId",
              isEqualTo:
                  Provider.of<OrganisationNotifier>(context, listen: false)
                      .organisation
                      .id)
          .where('id', isGreaterThanOrEqualTo: textController!.text)
          .where('id', isLessThan: textController!.text + 'z')
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const CircularProgressIndicator(
            color: Color.fromARGB(0, 0, 0, 0),
          );
        }
        return Expanded(
          child: ListView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemCount: snapshot.data?.docs.length,
            itemBuilder: (context, index) => DriverCard(
              snapshot.data?.docs[index].get("id") as String,
              snapshot.data?.docs[index].get("name") as String,
              onTap: "go to driver-page",
            ),
          ),
        );
      },
    );
  }
}
