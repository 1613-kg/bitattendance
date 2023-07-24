class DepartmentData {
  String id;
  String name;
  String head;
  String addedBy;
  List<String> batches;

  DepartmentData(
      {required this.id,
      required this.name,
      required this.head,
      required this.batches,
      required this.addedBy});
}
