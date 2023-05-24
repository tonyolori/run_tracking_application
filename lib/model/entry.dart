import 'dart:math';
String generateRandomString(int len) {
  var r = Random();
  const chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  return List.generate(len, (index) => chars[r.nextInt(chars.length)]).join();
}

class Entry {
  static String table = "entries";

  String? id;
  String date;
  String duration;
  double speed;
  double distance;

  Entry({this.id, required this.date, required this.duration, required this.speed, required this.distance}){
   
    id ??= generateRandomString(16);
     
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'date': date,
      'duration': duration,
      'speed': speed,
      'distance': distance
    };

    if (id != null) {
      map['id'] = id;
    }

    return map;
  }

  static Entry fromMap(Map<String, dynamic> map) {
    return Entry(
        //id: map['id'],
        date: map['date'],
        duration: map['duration'],
        speed: map['speed'],
        distance: map['distance']);
  }
}
