import 'package:flutter/foundation.dart';

import '../data/organisation.dart';

class OrganisationNotifier extends ChangeNotifier {
  Organisation _organisation = Organisation(id: "", name: "", admins: []);

  Organisation get organisation => _organisation;

  void set(Organisation newOrganisation) {
    _organisation = newOrganisation;
    notifyListeners();
  }

  void updat({String? name, List<String>? admins}) {
    if (name != null) {
      _organisation.name = name;
    }

    if (admins != null) {
      admins.forEach((element) {
        _organisation.admins.add(element);
      });
    }

    notifyListeners();
  }

  bool removeAdmine(String user) {
    if (_organisation.admins.contains(user)) {
      return false;
    }
    _organisation.admins.remove(user);
    notifyListeners();
    return true;
  }
}
