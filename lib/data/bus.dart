class Bus {
  String id;
  String imei;
  String oId;

  Bus({required this.id, required this.imei, required this.oId});

  void set(Bus bus) {
    id = bus.id;
    imei = bus.imei;
    oId = bus.oId;
  }
}
