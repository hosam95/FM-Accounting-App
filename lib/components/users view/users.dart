import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fm_accounting_app/components/users%20view/add_user.dart';
import 'package:fm_accounting_app/data/account.dart';
import 'package:fm_accounting_app/notifiers/organisation_notifier.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'user_card.dart';

class UsersView extends StatelessWidget {
  const UsersView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const AddUserCard(),
        Expanded(
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("users")
                  .where("oIds",
                      arrayContains: Provider.of<OrganisationNotifier>(context,
                              listen: false)
                          .organisation
                          .id)
                  //.where("id",
                  //    isNotEqualTo:
                  //        Provider.of<Account>(context, listen: false).phone)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const CircularProgressIndicator(
                    color: Color.fromARGB(0, 0, 0, 0),
                  );
                }

                return ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      if (snapshot.data!.docs[index].id ==
                          Provider.of<Account>(context, listen: false).phone) {
                        return const SizedBox();
                      }

                      return UserCard(
                        snapshot.data!.docs[index].id,
                        snapshot.data!.docs[index].get("name") as String,
                        false,
                        onTap: () =>
                            context.goNamed("accountant-page", queryParams: {
                          'name': snapshot.data!.docs[index].get("name"),
                          'phone': snapshot.data!.docs[index].id,
                        }),
                      );
                    });
              },
            ),
          ),
        ),
      ],
    );
  }
}
