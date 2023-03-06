import 'package:flutter/material.dart';
import 'package:fm_accounting_app/data/partition.dart';
import 'package:fm_accounting_app/notifiers/organisation_notifier.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../data/driver.dart';

class DriverCard extends StatelessWidget {
  final String id;
  final String name;
  final String? onTap;
  final bool isSelected;

  const DriverCard(this.id, this.name,
      {this.onTap, this.isSelected = false, super.key});

  @override
  Widget build(BuildContext context) {
    Map onTapFunction = {
      "update driver and pop": (BuildContext context) {
        Provider.of<Driver>(context, listen: false).set(Driver(
          id: id,
          name: name,
          oId: Provider.of<OrganisationNotifier>(context, listen: false)
              .organisation
              .id,
          bId: Provider.of<Partition>(context, listen: false).id,
        ));
        context.goNamed("new-payment");
      },
      "go to search-page": (BuildContext context) {
        context.goNamed("search-page", queryParams: {'type': "driver"});
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
          height: 90,
          decoration: BoxDecoration(
            color: isSelected
                ? Color.fromARGB(255, 109, 145, 237)
                : const Color.fromARGB(255, 194, 192, 192),
            boxShadow: const [
              BoxShadow(
                blurRadius: 0,
                color: Color(0x33000000),
                offset: Offset(0, 2),
              )
            ],
            borderRadius: BorderRadius.circular(5),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                        const EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
                    child: Text(
                      id,
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
                child: Text(
                  name,
                  style: const TextStyle(
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
