abstract class StorableObject {
  DateTime time;
  late int year;
  late int month;
  late int day;

  Map<String, dynamic> toMap();

  StorableObject({required this.time});
}
