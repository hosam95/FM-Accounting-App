import 'package:flutter/material.dart';
import 'package:fm_accounting_app/components/buss%20view/bus_card.dart';
import 'package:fm_accounting_app/data/bus.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class BusSelector extends StatelessWidget {
  const BusSelector({super.key});

  @override
  Widget build(BuildContext context) {
    if (Provider.of<Bus>(context, listen: false).id == "") {
      return noBusSelected(context);
    }
    return selectedBus(context);
  }

  Widget noBusSelected(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          minimumSize: Size.fromHeight(40),
          backgroundColor: Color.fromRGBO(32, 38, 118, 0.897),
        ),
        onPressed: () {
          // TODO(hosam95):go to select bus page.
          context.goNamed("search-page", queryParams: {'type': "bus"});
        },
        child: Text("Select Bus"),
      ),
    );
  }

  Widget selectedBus(BuildContext context) {
    Bus bus = Provider.of<Bus>(context, listen: false);
    return BusCard(
      bus.imei,
      onTap: "go to search-page",
    );
  }
}
