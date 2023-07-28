class EventData {
  String eventId;
  String name;
  String type;
  String location;
  String startDate;
  String endDate;
  String startTime;
  String endTime;
  String description;
  List<String> images;
  String addedBy;
  DateTime timeStamp;

  EventData({
    required this.timeStamp,
    required this.eventId,
    required this.name,
    required this.description,
    required this.type,
    required this.location,
    required this.endDate,
    required this.startDate,
    required this.images,
    required this.startTime,
    required this.endTime,
    required this.addedBy,
  });
}
