import 'package:flutter/material.dart';
import 'package:fm_accounting_app/components/buss%20view/add_bus.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fm_accounting_app/notifiers/organisation_notifier.dart';
import 'package:provider/provider.dart';

import 'bus_card.dart';

class BussView extends StatelessWidget {
  const BussView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const AddBussCard(),
        Expanded(
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
            child: Container(
              width: double.infinity,
              height: 100,
              decoration: const BoxDecoration(
                color: Color(0xFFEFEBEB),
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
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("buss")
                    .where("oId",
                        isEqualTo: Provider.of<OrganisationNotifier>(context,
                                listen: false)
                            .organisation
                            .id)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData)
                    return CircularProgressIndicator(
                      color: Color.fromARGB(0, 0, 0, 0),
                    );
                  return ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount: snapshot.data?.docs.length,
                    itemBuilder: (context, index) => BusCard(
                      snapshot.data?.docs[index].get("imei") as String,
                    ),
                  );
                },
              ),
            ),
          ),
        )
      ],
    );
  }
}
