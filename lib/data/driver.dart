class Driver {
  String id;
  String name;
  String oId;
  String? bId;

  Driver({required this.id, required this.name, required this.oId, this.bId});

  void set(Driver driver) {
    id = driver.id;
    name = driver.name;
    oId = driver.oId;
    bId = driver.bId;
  }
}
