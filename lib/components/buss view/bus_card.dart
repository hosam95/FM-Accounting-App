import 'package:flutter/material.dart';
import 'package:fm_accounting_app/notifiers/organisation_notifier.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../data/bus.dart';

class BusCard extends StatelessWidget {
  String id;
  final String imei;
  final String? onTap;
  final bool isSelected;
  BusCard(this.imei,
      {this.id = "", this.onTap, this.isSelected = false, super.key});

  @override
  Widget build(BuildContext context) {
    Map onTapFunction = {
      "update bus and pop": (BuildContext context) {
        Provider.of<Bus>(context, listen: false).set(Bus(
          id: id,
          imei: imei,
          oId: Provider.of<OrganisationNotifier>(context, listen: false)
              .organisation
              .id,
        ));
        context.goNamed("new-payment");
      },
      "go to search-page": (BuildContext context) {
        context.goNamed("search-page", queryParams: {'type': "bus"});
      },
    };

    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
      child: InkWell(
        onTap: () {
          onTap == null ? null : onTapFunction[onTap](context);
        },
        child: Container(
          width: double.infinity,
          height: 60,
          /*color: isSelected
              ? Color.fromARGB(0, 31, 34, 115)
              : const Color.fromARGB(0, 233, 232, 232), */
          decoration: BoxDecoration(
            color: isSelected
                ? Color.fromARGB(255, 109, 145, 237)
                : Color.fromARGB(255, 194, 192, 192),
            boxShadow: const [
              BoxShadow(
                blurRadius: 0,
                color: Color(0x33000000),
                offset: Offset(0, 2),
              )
            ],
            borderRadius: BorderRadius.circular(5),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
                child: Text(
                  imei,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
