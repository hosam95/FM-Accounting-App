import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fm_accounting_app/components/partitions%20view/partition_card.dart';
import 'package:fm_accounting_app/data/partition.dart';
import 'package:fm_accounting_app/notifiers/organisation_notifier.dart';
import 'package:provider/provider.dart';

import 'add_partition.dart';

class PartitionView extends StatelessWidget {
  const PartitionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const AddPartitionCard(),
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
                    .collection("partitions")
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
                    itemBuilder: (context, index) => PartitionCard(
                      Partition(
                          id: snapshot.data?.docs[index].id as String,
                          oId: snapshot.data?.docs[index].get("oId") as String,
                          name:
                              snapshot.data?.docs[index].get("name") as String),
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
