import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fm_accounting_app/notifiers/organisation_notifier.dart';
import 'package:provider/provider.dart';

import 'data/account.dart';
import 'data/organisation.dart';
import 'pages/home_page.dart';
import 'pages/login.dart';

class AuthGate extends StatelessWidget {
  FirebaseFirestore db = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase Example App',
      theme: ThemeData(primarySwatch: Colors.amber),
      home: Scaffold(
        body: LayoutBuilder(
          builder: (context, constraints) {
            return Row(
              children: [
                Visibility(
                  visible: constraints.maxWidth >= 1200,
                  child: Expanded(
                    child: Container(
                      height: double.infinity,
                      color: Theme.of(context).colorScheme.primary,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Firebase Auth Desktop',
                              style: Theme.of(context).textTheme.headline4,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: constraints.maxWidth >= 1200
                      ? constraints.maxWidth / 2
                      : constraints.maxWidth,
                  child: StreamBuilder<User?>(
                    stream: FirebaseAuth.instance.authStateChanges(),
                    builder: (context, snapshot) {
                      /*if (snapshot.connectionState == ConnectionState.none) {
                        return const LoadingPage();
                      }*/
                      if (!snapshot.hasData) {
                        return LoginPage();
                      }
                      fetchBasicData(context, snapshot.data);

                      return const HomePageWidget();
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
    /*return Scaffold(
      body: Center(
        child: Text('FM Accounting Home Page'),
      ),
    );*/
  }

  void fetchBasicData(context, data) async {
    var userOIds;
    await db.collection("users").doc(data!.phoneNumber!).get().then((value) {
      userOIds = value.get("oIds");
      print(value.get("oIds"));
      Provider.of<Account>(context, listen: false).set(
          uid: data!.uid,
          phone: data!.phoneNumber!,
          name: value.get("name"),
          oIds: value.get("oIds"));
    });

    if (userOIds.length == 0) {
      return;
    }
    //get organisation if exists
    String oId = Provider.of<Account>(context, listen: false).oIds[0];
    db.collection("organisations").doc(oId).get().then((oVal) {
      Provider.of<OrganisationNotifier>(context, listen: false).set(
          Organisation(
              id: oId, name: oVal.get("name"), admins: oVal.get("admins")));
    });
  }
}
