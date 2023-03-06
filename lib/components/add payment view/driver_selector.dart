import 'package:flutter/material.dart';
import 'package:fm_accounting_app/components/drivers%20view/driver_card.dart';
import 'package:fm_accounting_app/data/driver.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class DriverSelector extends StatelessWidget {
  const DriverSelector({super.key});

  @override
  Widget build(BuildContext context) {
    if (Provider.of<Driver>(context, listen: false).id == "") {
      return noDriverSelected(context);
    }
    return selectedDriver(context);
  }

  Widget noDriverSelected(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Color.fromRGBO(32, 38, 118, 0.897),
          minimumSize: Size.fromHeight(40),
        ),
        onPressed: () {
          // TODO(hosam95):go to select driver page.
          context.goNamed("search-page", queryParams: {'type': "driver"});
        },
        child: Text("Select Driver"),
      ),
    );
  }

  Widget selectedDriver(BuildContext context) {
    Driver driver = Provider.of<Driver>(context, listen: false);
    return DriverCard(
      driver.id,
      driver.name,
      onTap: "go to search-page",
    );
  }
}
