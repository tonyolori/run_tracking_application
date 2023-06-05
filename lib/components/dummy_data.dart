import '../model/calorie_model.dart';

String toMonthSt(int month) {
  switch (month) {
    case 1:
      return "jan";

    case 2:
      return "feb";

    case 3:
      return "mar";

    case 4:
      return "apr";

    case 5:
      return "may";

    case 6:
      return "jun";

    case 7:
      return "jul";

    case 8:
      return "aug";

    case 9:
      return "sept";

    case 10:
      return "oct";

    case 11:
      return "nov";

    case 12:
      return "dec";

    default:
      return "invalid";
  }
}

String toDaySt(int day) {
  switch (day) {
    case 7:
      return "Sunday";

    case 1:
      return "Monday";

    case 2:
      return "Tuesday";

    case 3:
      return "Wednesday";
    case 4:
      return "Thursday";

    case 5:
      return "Friday";
    case 6:
      return "Saturday";
    default:
      return " invalid entry";
  }
}


final List<Map<String, dynamic>> dummyCalorieData = [
  {
    'id': 'Bar',
    'data': [
      {'domain': 'jan', 'measure': 3},
      {'domain': 'feb', 'measure': 4},
      {'domain': 'march', 'measure': 6},
      {'domain': 'april', 'measure': 0.3},
      {'domain': 'may', 'measure': 3},
      {'domain': 'june', 'measure': 4},
      {'domain': 'july', 'measure': 6},
      {'domain': 'Aug', 'measure': 0.3},
      {'domain': 'Sept', 'measure': 3},
      {'domain': 'Oct', 'measure': 4},
      {'domain': 'Nov', 'measure': 6},
      {'domain': 'Dec', 'measure': 0.3},
    ],
  },
];


final List<Map<String, dynamic>> calorieMaps = [
  {
    columnCalorieCount: 1900,
    columnTime: "2023-05-01 18:08:46.385056",
  },
  {
    columnCalorieCount: 2100,
    columnTime: "2023-06-01 18:08:46.385056",
  },
];

List<Map<String, dynamic>> dummyBarDataWeekly = [
  {
    'id': 'Bar',
    'data': [
      {'domain': 'Sun', 'measure': 6},
      {'domain': 'Mon', 'measure': 3},
      {'domain': 'Tues', 'measure': 4},
      {'domain': 'Wed', 'measure': 6},
      {'domain': 'Thur', 'measure': 0.3},
      {'domain': 'Fri', 'measure': 3},
      {'domain': 'Sat', 'measure': 4},
    ],
  },
];
