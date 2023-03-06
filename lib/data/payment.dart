class Payment {
  String id;
  int amount;
  String driverId;
  String driverName;
  String busId;
  String accountantId;
  String accountantName;
  int time;
  String pId;
  String oId;
  bool checked = false;
  bool upToDate = true;
  int updatedAt = 0;
  String updatedBy = "";

  Payment({
    required this.id,
    required this.amount,
    required this.driverId,
    required this.driverName,
    required this.busId,
    required this.accountantId,
    required this.accountantName,
    required this.time,
    required this.pId,
    required this.oId,
    this.checked = false,
    this.upToDate = true,
    this.updatedAt = 0,
    this.updatedBy = "",
  });

  Payment.deserializer(Map<String, dynamic> map)
      : id = map.containsKey("id") ? map["id"] : "",
        amount = map.containsKey("amount") ? map["amount"] : 0,
        driverId = map.containsKey("driverId") ? map["driverId"] : "",
        driverName = map.containsKey("driverName") ? map["driverName"] : "",
        busId = map.containsKey("busId") ? map["busId"] : "",
        accountantId =
            map.containsKey("accountantId") ? map["accountantId"] : "",
        accountantName =
            map.containsKey("accountantName") ? map["accountantName"] : "",
        time = map.containsKey("time") ? map["time"] : 0,
        pId = map.containsKey("pId") ? map["pId"] : "",
        oId = map.containsKey("oId") ? map["oId"] : "",
        checked = map.containsKey("checked") ? map["checked"] : false,
        upToDate = map.containsKey("upToDate") ? map["upToDate"] : true,
        updatedAt = map.containsKey("updatedAt") ? map["updatedAt"] : 0,
        updatedBy = map.containsKey("updatedBy") ? map["updatedBy"] : "";

  Map<String, dynamic> fireStoreMap() {
    return {
      "id": id,
      "amount": amount,
      "driverId": driverId,
      "driverName": driverName,
      "busId": busId,
      "accountantId": accountantId,
      "accountantName": accountantName,
      "time": time,
      "pId": pId,
      "oId": oId,
      "checked": checked,
      "upToDate": upToDate,
      "updatedAt": updatedAt,
      "updatedBy": updatedBy
    };
  }
}
