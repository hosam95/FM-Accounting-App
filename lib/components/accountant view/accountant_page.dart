import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../data/payment.dart';
import '../payment_card.dart';

class AccountantPage extends StatelessWidget {
  final String? name;
  final String? phone;

  AccountantPage({required this.name, required this.phone, super.key});

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F4F8),
      appBar: AppBar(
        backgroundColor: const Color(0xFF4B39EF),
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: Colors.white,
            size: 24,
          ),
          onPressed: () async {
            context.pop();
          },
        ),
        title: const Text(
          'Safe Detail',
          style: TextStyle(
            fontFamily: 'Lexend Deca',
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: const [],
        centerTitle: false,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 12),
                child: Expanded(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: const BoxDecoration(
                      color: Color(0xFF4B39EF),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 5,
                          color: Color(0x32171717),
                          offset: Offset(0, 2),
                        )
                      ],
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(16),
                        bottomRight: Radius.circular(16),
                        topLeft: Radius.circular(0),
                        topRight: Radius.circular(0),
                      ),
                    ),
                    child: Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 12),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                20, 0, 20, 0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            0, 4, 0, 0),
                                    child: Text(
                                      name!,
                                      style: const TextStyle(
                                        fontFamily: 'Lexend Deca',
                                        color: Colors.white,
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                20, 0, 20, 0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            0, 12, 0, 0),
                                    child: StreamBuilder(
                                      stream: _firestore
                                          .collection("payments")
                                          .where("checked", isEqualTo: false)
                                          .where("accountantId",
                                              isEqualTo: phone)
                                          .snapshots(),
                                      builder: (context, snapshot) {
                                        if (!snapshot.hasData) {
                                          return const Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    5, 5, 5, 5),
                                            child: CircularProgressIndicator(
                                              color: Color.fromARGB(
                                                  255, 95, 88, 88),
                                            ),
                                          );
                                        }

                                        int counter = 0;
                                        for (int i = 0;
                                            i < snapshot.data!.docs.length;
                                            i++) {
                                          counter += snapshot.data!.docs[i]
                                              .get("amount") as int;
                                        }

                                        return Text(
                                          '$counter EGP',
                                          style: const TextStyle(
                                            fontFamily: 'Lexend Deca',
                                            color: Colors.white,
                                            fontSize: 36,
                                            fontWeight: FontWeight.normal,
                                          ),
                                        );
                                      },
                                    )),
                                const Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      8, 0, 0, 4),
                                  child: Text(
                                    'Uncollected',
                                    style: TextStyle(
                                      fontFamily: 'Lexend Deca',
                                      color: Color(0xB3FFFFFF),
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  10, 10, 10, 0),
                              child: ButtonTheme(
                                minWidth: double.infinity,
                                height: 40,
                                shape: const RoundedRectangleBorder(),
                                child: ElevatedButton(
                                  onPressed: () {
                                    _firestore
                                        .collection("payments")
                                        .where("checked", isEqualTo: false)
                                        .where("accountantId", isEqualTo: phone)
                                        .get()
                                        .then((value) {
                                      var batch = _firestore.batch();
                                      value.docs.forEach((doc) => _firestore
                                          .collection("payments")
                                          .doc(doc.id)
                                          .set({"checked": true},
                                              SetOptions(merge: true)));
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF11192A),
                                    side: const BorderSide(
                                      color: Colors.transparent,
                                      width: 1,
                                    ),
                                  ),
                                  child: const Text('Check Out'),
                                ),
                              )),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: const [
                        Expanded(
                          child: Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(0, 12, 0, 0),
                            child: Text(
                              'Payments',
                              style: TextStyle(
                                fontFamily: 'Lexend Deca',
                                color: Color(0xFF090F13),
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  StreamBuilder(
                    stream: _firestore
                        .collection("payments")
                        .where("checked", isEqualTo: false)
                        .where("accountantId", isEqualTo: phone)
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
                        return const Text("no payments found");
                      }

                      return ListView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemCount: snapshot.data?.docs.length,
                        itemBuilder: (context, index) {
                          return PaymentCard(Payment.deserializer(
                              snapshot.data!.docs[index].data()
                                  as Map<String, dynamic>));
                        },
                      );
                    },
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
