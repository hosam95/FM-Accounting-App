import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'data/account.dart';
import 'pages/home_page.dart';
import 'pages/login.dart';

class AuthGate extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    FirebaseFirestore db = FirebaseFirestore.instance;
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
                      db
                          .collection("users")
                          .doc(snapshot.data!.phoneNumber!)
                          .get()
                          .then((value) {
                        print(value.get("oIds"));
                        Provider.of<Account>(context, listen: false).set(
                            uid: snapshot.data!.uid,
                            phone: snapshot.data!.phoneNumber!,
                            name: value.get("name"),
                            oIds: value.get("oIds"));
                      });

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
}
