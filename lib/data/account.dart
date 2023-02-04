class Account {
  String uid;
  String name;
  String phone;
  List oIds;

  Account(
      {required this.uid,
      required this.name,
      required this.phone,
      required this.oIds});

  void set({String? uid, String? name, String? phone, List? oIds}) {
    if (uid != null) {
      this.uid = uid;
    }

    if (name != null) {
      this.name = name;
    }

    if (phone != null) {
      this.phone = phone;
    }

    if (oIds != null) {
      oIds.forEach((element) {
        this.oIds.add(element);
      });
    }
  }

  void resetOIds(List oIds) {
    this.oIds = oIds;
  }
}
