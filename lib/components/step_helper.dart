import '../database/step_data.dart' as database;
import '../database/step.dart';

class StepHelper {
  List<Step> _steps =[];

  inputStep(Step step) async {
    await database.innit();
    database.insertStep(step);

    print(await database.getAllSteps());
    //database.dropTable();
  }
  getStepsInMonth(int month){

  }
}
