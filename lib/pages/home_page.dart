import 'package:flutter/material.dart';
import 'package:fm_accounting_app/components/users%20view/users.dart';
import 'package:fm_accounting_app/data/partition.dart';
import 'package:fm_accounting_app/notifiers/organisation_notifier.dart';
import 'package:fm_accounting_app/pages/profile.dart';
import 'package:provider/provider.dart';

import '../components/buss view/buss.dart';
import '../components/drivers view/drivers.dart';
import '../components/partitions view/partitions.dart';

class HomePageWidget extends StatefulWidget {
  const HomePageWidget({super.key});

  @override
  State<HomePageWidget> createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget> {
  int currentPageIndex = 2;

  @override
  Widget build(BuildContext context) {
    Provider.of<Partition>(context, listen: false).set(Partition(
        id: "",
        oId: Provider.of<OrganisationNotifier>(context, listen: false)
            .organisation
            .id,
        name: ""));
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            icon: Icon(Icons.account_box),
            label: 'Profile',
          ),
          NavigationDestination(
            icon: Icon(Icons.supervisor_account),
            label: 'Accounts',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.house),
            icon: Icon(Icons.house),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.directions_bus_outlined),
            label: 'Buss',
          ),
          NavigationDestination(
            icon: Icon(Icons.directions_bike),
            label: 'Drivers',
          ),
        ],
      ),
      body: <Widget>[
        networkCheck(const ProfilePage()),
        Container(
          color: Color.fromARGB(255, 231, 229, 137),
          alignment: Alignment.center,
          child: networkCheck(const UsersView()),
        ),
        Container(
          color: Color.fromARGB(255, 128, 134, 103),
          alignment: Alignment.center,
          child: networkCheck(const PartitionView()),
        ),
        networkCheck(const BussView()),
        Container(
          color: Colors.blue,
          alignment: Alignment.center,
          child: networkCheck(const DriversView()),
        ),
      ][currentPageIndex],
    );
  }

  Widget networkCheck(Widget page) {
    bool isOk = Provider.of<OrganisationNotifier>(context, listen: false)
            .organisation
            .id !=
        "";
    return isOk
        ? page
        : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "Network Error",
                style: TextStyle(color: Color.fromARGB(0, 177, 9, 9)),
              ),
              ElevatedButton(
                  onPressed: () => setState(() {}), child: const Text("retry")),
            ],
          );
  }
}
