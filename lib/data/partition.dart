class Partition {
  String id;
  String oId;
  String name;

  Partition({required this.id, required this.oId, required this.name});

  void set(Partition partition) {
    id = partition.id;
    name = partition.name;
    oId = partition.oId;
  }
}
