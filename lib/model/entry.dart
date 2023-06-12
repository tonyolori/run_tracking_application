import 'dart:math';
String generateRandomString() {
  var r = Random();
  const chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  return List.generate(16, (index) => chars[r.nextInt(chars.length)]).join();
}

class Entry {
  static String table = "entries";

  String uid;
  String rid;
  String date;
  String duration;
  double speed;
  double distance;

  Entry({required this.uid,required this.rid, required this.date, required this.duration, required this.speed, required this.distance}){}

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'uid': uid,
      'rid': rid,
      'date': date,
      'duration': duration,
      'speed': speed,
      'distance': distance
    };


    return map;
  }

  static Entry fromMap(Map<String, dynamic> map) {
    return Entry(
        uid: map['uid'],
        rid: map['rid'],
        date: map['date'],
        duration: map['duration'],
        speed: map['speed'],
        distance: map['distance']);
  }
  //
}
