import 'package:flutter/material.dart';
import 'package:fm_accounting_app/components/accountant%20view/accountant_page.dart';
import 'package:fm_accounting_app/components/add%20payment%20view/add_payment.dart';
import 'package:fm_accounting_app/components/add%20payment%20view/search_page.dart';
import 'package:fm_accounting_app/data/account.dart';
import 'package:fm_accounting_app/pages/home_page.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'Authentication.dart';
import 'data/bus.dart';
import 'data/driver.dart';
import 'data/partition.dart';
import 'firebase_options.dart';
import 'notifiers/organisation_notifier.dart';
import 'loading_page.dart';
import 'pages/login.dart';
import 'pages/register.dart';

bool shouldUseFirebaseEmulator = false;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // We're using the manual installation on non-web platforms since Google sign in plugin doesn't yet support Dart initialization.
  // See related issue: https://github.com/flutter/flutter/issues/96391

  await Firebase.initializeApp(
    name: 'FM-Accounting',
    options: DefaultFirebaseOptions.currentPlatform,
  );

  if (shouldUseFirebaseEmulator) {
    await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
  }

  runApp(const MyApp());
}

/// The route configuration.
final GoRouter _router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return AuthGate();
      },
    ),
    GoRoute(
      name: "login",
      path: '/login',
      builder: (BuildContext context, GoRouterState state) {
        return LoginPage();
      },
    ),
    GoRoute(
      name: "register",
      path: '/register',
      builder: (BuildContext context, GoRouterState state) {
        return RegisterPage();
      },
    ),
    GoRoute(
      name: "loading",
      path: '/loading',
      builder: (BuildContext context, GoRouterState state) {
        return const LoadingPage();
      },
    ),
    GoRoute(
      name: "home",
      path: '/home',
      builder: (BuildContext context, GoRouterState state) {
        return const HomePageWidget();
      },
      routes: <RouteBase>[
        GoRoute(
          name: "new-payment",
          path: 'partition/new-payment',
          builder: (BuildContext context, GoRouterState state) {
            return const AddPaymentView();
          },
          routes: <RouteBase>[
            GoRoute(
              name: "search-page",
              path: 'search',
              builder: (context, state) {
                return SearchPage(
                  type: state.queryParams['type'],
                );
              },
            )
          ],
        ),
        GoRoute(
          name: "accountant-page",
          path: 'accountant-page',
          builder: (context, state) {
            return AccountantPage(
              name: state.queryParams['name'],
              phone: state.queryParams['phone'],
            );
          },
        ),
      ],
    ),
  ],
);

/// The main app.
class MyApp extends StatelessWidget {
  /// Constructs a [MyApp]
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(
            create: (context) =>
                Account(uid: "", name: "", phone: "", oIds: [])),
        ChangeNotifierProvider(create: (context) => OrganisationNotifier()),
        Provider(
          create: (context) => Partition(
              id: "",
              name: "",
              oId: Provider.of<OrganisationNotifier>(context, listen: false)
                  .organisation
                  .id),
        ),
        Provider(
            create: (context) => Bus(
                id: "",
                imei: "",
                oId: Provider.of<OrganisationNotifier>(context, listen: false)
                    .organisation
                    .id)),
        Provider(
            create: (context) => Driver(
                id: "",
                name: "",
                oId: Provider.of<OrganisationNotifier>(context, listen: false)
                    .organisation
                    .id)),
      ],
      child: MaterialApp.router(
        routerConfig: _router,
      ),
    );
  }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright 2022, the Chromium project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
/*
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'auth.dart';
import 'profile.dart';

import 'firebase_options.dart';

/// Requires that a Firebase local emulator is running locally.
/// See https://firebase.flutter.dev/docs/auth/start/#optional-prototype-and-test-with-firebase-local-emulator-suite
bool shouldUseFirebaseEmulator = false;

// Requires that the Firebase Auth emulator is running locally
// e.g via `melos run firebase:emulator`.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // We're using the manual installation on non-web platforms since Google sign in plugin doesn't yet support Dart initialization.
  // See related issue: https://github.com/flutter/flutter/issues/96391

  await Firebase.initializeApp(
    name: 'FM-Accounting',
    options: DefaultFirebaseOptions.currentPlatform,
  );

  if (shouldUseFirebaseEmulator) {
    await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
  }

  runApp(const AuthExampleApp());
}

/// The entry point of the application.
///
/// Returns a [MaterialApp].
class AuthExampleApp extends StatelessWidget {
  const AuthExampleApp({Key? key}) : super(key: key);

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
                      if (snapshot.hasData) {
                        return const ProfilePage();
                      }
                      return const AuthGate();
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
*/
