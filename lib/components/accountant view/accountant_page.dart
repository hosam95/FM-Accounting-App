import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:date_time_picker/date_time_picker.dart';

import '../../data/payment.dart';
import '../payment_card.dart';

class AccountantPage extends StatefulWidget {
  final String? name;
  final String? identifier;
  const AccountantPage(
      {required this.name, required this.identifier, super.key});

  @override
  State<AccountantPage> createState() =>
      _AccountantPageState(name: name, identifier: identifier);
}

class _AccountantPageState extends State<AccountantPage> {
  final String? name;
  final String? identifier;
  TextEditingController startController = TextEditingController();
  TextEditingController endController = TextEditingController();
  String start = '';
  String end = '';
  bool queryNotChecked = true;
  bool showConfirmCheckOut = false;
  bool showDurationView = false;
  bool isDisabled = false;

  _AccountantPageState({required this.name, required this.identifier});

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    // TODO: implement initState
    start = getLast3Am().toString();
    end = getNext3Am().toString();
    startController.text = start;
    endController.text = end;

    super.initState();
  }

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
          'Safe Details',
          style: TextStyle(
            fontFamily: 'Lexend Deca',
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: [
          IconButton(
            color: Colors.white,
            onPressed: () {
              if (isDisabled) return;

              setState(() {
                showDurationView = true;
                isDisabled = true;
              });
            },
            icon: const Icon(
              Icons.edit_calendar_rounded,
            ),
          ),
        ],
        centerTitle: false,
        elevation: 0,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
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
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(0, 4, 0, 0),
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
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(0, 12, 0, 0),
                                        child: StreamBuilder(
                                          stream: getQuery(),
                                          builder: (context, snapshot) {
                                            if (snapshot.hasError) {
                                              return Text(
                                                  'Error: ${snapshot.error}');
                                            }

                                            if (!snapshot.hasData) {
                                              return const Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(5, 5, 5, 5),
                                                child:
                                                    CircularProgressIndicator(
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
                                        'Total',
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
                              //hos
                              const SizedBox(
                                height: 5,
                              ),
                              ...rangeCheckoutSwitch(),
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
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 0),
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
                        stream: getQuery(),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          }
                          print('DATA: ${snapshot.data?.docs}');
                          if (!snapshot.hasData) {
                            return const Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(5, 5, 5, 5),
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
            ...confirmCheckOutWidget(),
            ...dateRangePicker(),
          ],
        ),
      ),
    );
  }

  List<Widget> rangeCheckoutSwitch() {
    if (queryNotChecked) {
      return [
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(10, 10, 10, 0),
          child: ElevatedButton(
            onPressed: () {
              if (isDisabled) return;

              setState(() {
                showConfirmCheckOut = true;
                isDisabled = true;
              });
            },
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(150, 37),
              backgroundColor: const Color(0xFF11192A),
              side: const BorderSide(
                color: Colors.transparent,
                width: 1,
              ),
            ),
            child: const Text('Check Out'),
          ),
        ),
      ];
    }

    return [
      Text(
        start.substring(0, 16),
        style: const TextStyle(
          fontSize: 12,
          color: Colors.white,
        ),
      ),
      const Text(
        'to',
        style: TextStyle(
          fontSize: 12,
          color: Colors.white,
        ),
      ),
      Text(
        end.substring(0, 16),
        style: const TextStyle(
          fontSize: 12,
          color: Colors.white,
        ),
      ),
    ];
  }

  String getDateAsString(DateTime time) {
    String formatedTime =
        "${time.year}-${time.month}-${time.day}\n${time.hour % 12}:${time.minute} ${time.hour < 12 ? 'AM' : 'PM'}";

    return formatedTime;
  }

  List<Widget> confirmCheckOutWidget() {
    if (!showConfirmCheckOut) return [];

    return [
      GestureDetector(
        onTap: () {
          setState(() {
            showConfirmCheckOut = false;
            isDisabled = false;
          });
        },
        child: Container(
          color: Color.fromARGB(0, 0, 0, 0),
          width: MediaQuery.of(context).size.width * 1,
          height: MediaQuery.of(context).size.height * 1,
        ),
      ),
      SizedBox(
        width: MediaQuery.of(context).size.width * 1,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.8,
              height: 150,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  const BoxShadow(
                    blurRadius: 100,
                    color: Color(0x33000000),
                    offset: Offset(2, 2),
                    spreadRadius: 200,
                  )
                ],
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  width: 1,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  const Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(15, 15, 15, 15),
                    child: Text(
                        "this action will set the uncollected amount of money to 0, are you sure you want to do this?"),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          _firestore
                              .collection("payments")
                              .where("checked", isEqualTo: false)
                              .where("accountantId", isEqualTo: identifier)
                              .get()
                              .then((value) {
                            value.docs.forEach((doc) => _firestore
                                .collection("payments")
                                .doc(doc.id)
                                .set({"checked": true},
                                    SetOptions(merge: true)));
                          });
                          setState(() {
                            showConfirmCheckOut = false;
                            isDisabled = false;
                          });
                        },
                        child: const Text('Comfirm'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            showConfirmCheckOut = false;
                            isDisabled = false;
                          });
                        },
                        child: const Text('Cancel'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      )
    ];
  }

  List<Widget> dateRangePicker() {
    if (!showDurationView) return [];

    return [
      GestureDetector(
        onTap: () {
          setState(() {
            showDurationView = false;
            isDisabled = false;
          });
        },
        child: Container(
          color: Color.fromARGB(0, 0, 0, 0),
          width: MediaQuery.of(context).size.width * 1,
          height: MediaQuery.of(context).size.height * 1,
        ),
      ),
      SizedBox(
        width: MediaQuery.of(context).size.width * 1,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.8,
              height: 350,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  const BoxShadow(
                    blurRadius: 100,
                    color: Color(0x33000000),
                    offset: Offset(2, 2),
                    spreadRadius: 200,
                  )
                ],
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  width: 1,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(10, 5, 10, 5),
                    child: Row(
                      children: const [
                        Text(
                          "Select filter",
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.7,
                    height: 210,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        width: 1,
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              10, 10, 10, 10),
                          child: DateTimePicker(
                            controller: startController,
                            type: DateTimePickerType.dateTime,
                            firstDate: DateTime(2000),
                            lastDate: DateTime(3000),
                            onSaved: (val) {
                              //TODO: do this.
                            },
                            decoration: const InputDecoration(
                              labelText: "start",
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              10, 10, 10, 10),
                          child: DateTimePicker(
                            controller: endController,
                            type: DateTimePickerType.dateTime,
                            firstDate: DateTime(2000),
                            lastDate: DateTime(3000),
                            onSaved: (val) {
                              //TODO: do this.
                            },
                            decoration: const InputDecoration(
                              labelText: "end",
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              start = startController.text;
                              end = endController.text;
                              queryNotChecked = false;
                              isDisabled = false;
                              showDurationView = false;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(150, 37),
                          ),
                          child: const Text("Don"),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        startController.text = getLast3Am().toString();
                        endController.text = getNext3Am().toString();
                        start = startController.text;
                        end = endController.text;
                        queryNotChecked = false;
                        isDisabled = false;
                        showDurationView = false;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(150, 37),
                      backgroundColor: Colors.amber,
                    ),
                    child: const Text("Today"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        queryNotChecked = true;
                        isDisabled = false;
                        showDurationView = false;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(150, 37),
                      backgroundColor: Colors.black,
                    ),
                    child: const Text(
                      "Not Checked",
                      style: TextStyle(
                        color: Color.fromARGB(255, 248, 238, 177),
                        decorationColor: Colors.amber,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      )
    ];
  }

  DateTime getLast3Am() {
    var now = DateTime.now();
    if (now.hour > 3) {
      return DateTime(now.year, now.month, now.day, 3);
    }
    return DateTime(now.year, now.month, now.day - 1, 3);
  }

  DateTime getNext3Am() {
    var now = DateTime.now();
    if (now.hour < 3) {
      return DateTime(now.year, now.month, now.day, 3);
    }
    return DateTime(now.year, now.month, now.day + 1, 3);
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getQuery() {
    if (queryNotChecked) {
      return _firestore
          .collection("payments")
          .where("checked", isEqualTo: false)
          .where("accountantId", isEqualTo: identifier)
          .snapshots();
    }

    return _firestore
        .collection("payments")
        .where("time",
            isGreaterThanOrEqualTo:
                DateTime.parse(start).millisecondsSinceEpoch)
        .where("time", isLessThan: DateTime.parse(end).millisecondsSinceEpoch)
        .where("accountantId", isEqualTo: identifier)
        .snapshots();
  }
}
