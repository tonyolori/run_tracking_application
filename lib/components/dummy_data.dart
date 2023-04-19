import '../model/step_model.dart' as step;

  
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


List<Map<String, dynamic>> dummyBarData = [
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

List<Map<String, dynamic>> maps = [
  {
    step.columnStepCount: 1900,
    step.columnTime: "2023-01-01 18:08:46.385056",
  },
  {
    step.columnStepCount: 1400,
    step.columnTime: "2023-02-01 18:08:46.385056",
  },
  {
    step.columnStepCount: 1100,
    step.columnTime: "2023-03-01 18:08:46.385056",
  },
  {
    step.columnStepCount: 1340,
    step.columnTime: "2023-03-02 18:08:46.385056",
  },
  {
    step.columnStepCount: 1300,
    step.columnTime: "2023-03-03 18:08:46.385056",
  },
  {
    step.columnStepCount: 1400,
    step.columnTime: "2023-03-04 18:08:46.385056",
  },
  {
    step.columnStepCount: 2500,
    step.columnTime: "2023-03-05 18:08:46.385056",
  },
  {
    step.columnStepCount: 1900,
    step.columnTime: "2023-03-06 18:08:46.385056",
  },
  {
    step.columnStepCount: 2000,
    step.columnTime: "2023-03-07 18:08:46.385056",
  },
  {
    step.columnStepCount: 2500,
    step.columnTime: "2023-03-08 18:08:46.385056",
  },
  {
    step.columnStepCount: 3000,
    step.columnTime: "2023-03-09 18:08:46.385056",
  },
  {
    step.columnStepCount: 2000,
    step.columnTime: "2023-03-10 18:08:46.385056",
  },
  {
    step.columnStepCount: 1500,
    step.columnTime: "2023-03-11 18:08:46.385056",
  },
  {
    step.columnStepCount: 1100,
    step.columnTime: "2023-03-12 18:08:46.385056",
  },
  {
    step.columnStepCount: 2300,
    step.columnTime: "2023-03-13 18:08:46.385056",
  },
  {
    step.columnStepCount: 1400,
    step.columnTime: "2023-03-14 18:08:46.385056",
  },
  {
    step.columnStepCount: 1900,
    step.columnTime: "2023-03-15 18:08:46.385056",
  },
  {
    step.columnStepCount: 1000,
    step.columnTime: "2023-03-16 18:08:46.385056",
  },
  {
    step.columnStepCount: 3000,
    step.columnTime: "2023-03-17 18:08:46.385056",
  },
  {
    step.columnStepCount: 1200,
    step.columnTime: "2023-04-01 18:08:46.385056",
  },
  {
    step.columnStepCount: 1900,
    step.columnTime: "2023-05-01 18:08:46.385056",
  },
  {
    step.columnStepCount: 2100,
    step.columnTime: "2023-06-01 18:08:46.385056",
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
