import 'package:flutter/material.dart';
import 'package:fm_accounting_app/data/partition.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class PartitionCard extends StatelessWidget {
  final Partition partition;
  const PartitionCard(this.partition, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
      child: InkWell(
        onTap: () {
          Provider.of<Partition>(context, listen: false).set(partition);
          context.go("/home/partition/new-payment");
        },
        child: Container(
          width: double.infinity,
          height: 60,
          decoration: BoxDecoration(
            color: Color.fromARGB(0, 233, 232, 232),
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
                child: Text(partition.name),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
