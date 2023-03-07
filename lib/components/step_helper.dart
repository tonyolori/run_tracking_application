import '../database/step_data.dart' as database;
import '../database/step.dart';

Future<void>   fillDatabase() async {
  await database.innit();

  var steps =  database.convertToStepList(maps);

  for (int i = 0; i < steps.length; i++) {
    database.insertStep(steps[i]);
  }
  return;
}

List<Map<String, dynamic>> maps = [
  
  {
    columnStepCount:13000,
    columnTime: "2023-01-01 18:08:46.385056",
  },
  {
    columnStepCount:1400,
    columnTime: "2023-02-01 18:08:46.385056",
  },
  {
    columnStepCount:11000,
    columnTime: "2023-03-01 18:08:46.385056",
  },
  {
    columnStepCount:13400,
    columnTime: "2023-03-02 18:08:46.385056",
  },
  {
    columnStepCount:13500,
    columnTime: "2023-03-03 18:08:46.385056",
  },
  {
    columnStepCount:13600,
    columnTime: "2023-03-04 18:08:46.385056",
  },
];
