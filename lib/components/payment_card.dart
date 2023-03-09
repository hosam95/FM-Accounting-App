import 'package:flutter/material.dart';
import 'package:fm_accounting_app/data/payment.dart';

class PaymentCard extends StatelessWidget {
  final Payment payment;
  final Function? onTap;

  const PaymentCard(this.payment, {this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    var time = DateTime.fromMillisecondsSinceEpoch(payment.time);
    String formatedTime =
        "${time.year}-${time.month}-${time.day}\n${time.hour % 12}:${time.minute} ${time.hour < 12 ? 'AM' : 'PM'}";
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(10, 5, 10, 5),
      child: InkWell(
        onTap: () {
          onTap == null ? null : onTap!();
        },
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 8),
          child: Expanded(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.92,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  const BoxShadow(
                    blurRadius: 3,
                    color: Color(0x35000000),
                    offset: Offset(0, 1),
                  )
                ],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: const Color(0xFFF1F4F8),
                  width: 1,
                ),
              ),
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(4, 4, 4, 4),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(8, 0, 0, 0),
                      child: Card(
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        color: const Color(0xFF4B39EF),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: const Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(8, 8, 8, 8),
                          child: Icon(
                            Icons.currency_pound_rounded,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              payment.driverName,
                              style: const TextStyle(
                                fontFamily: 'Lexend Deca',
                                color: Color.fromARGB(255, 0, 115, 255),
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0, 4, 0, 0),
                              child: Text(
                                payment.accountantName,
                                style: const TextStyle(
                                  fontFamily: 'Lexend Deca',
                                  color: Color(0xFF090F13),
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(12, 0, 12, 0),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            '${payment.amount.toString()} EGP',
                            textAlign: TextAlign.end,
                            style: const TextStyle(
                              fontFamily: 'Lexend Deca',
                              color: Color(0xFF090F13),
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                0, 4, 0, 0),
                            child: Text(
                              formatedTime,
                              textAlign: TextAlign.end,
                              style: const TextStyle(
                                fontFamily: 'Lexend Deca',
                                color: Color(0xFF95A1AC),
                                fontSize: 12,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/*

Container(
          width: double.infinity,
          height: 90,
          decoration: BoxDecoration(
            color: const Color.fromARGB(0, 233, 232, 232),
            boxShadow: const [
              BoxShadow(
                blurRadius: 0,
                color: Color(0x33000000),
                offset: Offset(0, 2),
              )
            ],
            borderRadius: BorderRadius.circular(5),
          ),
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      payment.pId,
                      style: const TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                Text(
                  payment.amount as String,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Color.fromARGB(255, 28, 39, 170),
                  ),
                ),
                Text(
                  "Driver: ${payment.driverName}",
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
                Text(
                  "Accountant: ${payment.accountantName}",
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      DateTime.fromMillisecondsSinceEpoch(payment.time)
                          as String,
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),*/