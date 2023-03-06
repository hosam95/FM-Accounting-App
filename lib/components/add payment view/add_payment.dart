import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fm_accounting_app/components/add%20payment%20view/bus_selector.dart';
import 'package:fm_accounting_app/data/account.dart';
import 'package:fm_accounting_app/data/bus.dart';
import 'package:fm_accounting_app/data/driver.dart';
import 'package:fm_accounting_app/data/partition.dart';
import 'package:fm_accounting_app/data/payment.dart';
import 'package:fm_accounting_app/notifiers/organisation_notifier.dart';
import 'package:provider/provider.dart';

import 'add_payment_providers.dart';
import 'driver_selector.dart';

class AddPaymentView extends StatefulWidget {
  const AddPaymentView({super.key});

  @override
  State<AddPaymentView> createState() => _AddPaymentViewState();
}

class _AddPaymentViewState extends State<AddPaymentView> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  TextEditingController? amountController = TextEditingController();
  String _amountErrorMessage = "";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AmountTextField(),
            const SizedBox(),
            const DriverSelector(),
            const SizedBox(),
            const BusSelector(),
            const SizedBox(),
            ElevatedButton(onPressed: savePayment, child: const Text("Save")),
          ],
        ),
      ),
    );
  }

  Widget AmountTextField() {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(5, 10, 5, 0),
      child: TextFormField(
        keyboardType: TextInputType.number,
        controller: amountController,
        obscureText: false,
        decoration: InputDecoration(
          labelText: 'Amount',
          hintText: 'enter the Amount of mony',
          errorText: _amountErrorMessage,
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
          errorBorder: UnderlineInputBorder(
            borderSide: const BorderSide(
              color: Color(0x00000000),
              width: 1,
            ),
            borderRadius: BorderRadius.circular(15),
          ),
          focusedErrorBorder: UnderlineInputBorder(
            borderSide: const BorderSide(
              color: Color(0x00000000),
              width: 1,
            ),
            borderRadius: BorderRadius.circular(15),
          ),
          filled: true,
          fillColor: Color.fromARGB(255, 174, 169, 169),
        ),
        textAlign: TextAlign.start,
      ),
    );
  }

  void savePayment() async {
    // TODO(hosam95): check the required conditions and save the payment on firestore
    Payment payment = Payment(
        id: "",
        amount: int.parse(amountController?.text as String),
        driverId: Provider.of<Driver>(context, listen: false).id,
        driverName: Provider.of<Driver>(context, listen: false).name,
        busId: Provider.of<Bus>(context, listen: false).id,
        accountantId: Provider.of<Account>(context, listen: false).phone,
        accountantName: Provider.of<Account>(context, listen: false).name,
        time: DateTime.now().millisecondsSinceEpoch,
        pId: Provider.of<Partition>(context, listen: false).id,
        oId: Provider.of<OrganisationNotifier>(context, listen: false)
            .organisation
            .id);

    var payment_map = payment.fireStoreMap();
    payment_map.remove("id");
    await _firestore.collection("payments").doc().set(payment_map);

    setState(() {});
  }
}
