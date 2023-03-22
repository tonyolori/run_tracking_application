import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

// /// Initializes shared_preference
// void sharedPrefInit() async {
//     try {
//         /// Checks if shared preference exist
//         Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
//         final SharedPreferences prefs = await _prefs;
//         prefs.getString("app-name");
//     } catch (err) {
//         /// setMockInitialValues initiates shared preference
//         /// Adds app-name 
//         SharedPreferences.setMockInitialValues({});
//         Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
//         final SharedPreferences prefs = await _prefs;
//         prefs.setString("app-name", "my-app");
//     }
// }
class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

addBoolToSF() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setBool('boolValue', true);
}

bool liveTrackingToggle = true;

class _SettingsPageState extends State<SettingsPage> {
  getBoolValuesSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return bool
    liveTrackingToggle = prefs.getBool('liveTrackingToggle') ?? true;
    if(mounted){
      setState(() {
        
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getBoolValuesSF();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SettingsList(
        sections: [
          SettingsSection(
            title: Text('Common'),
            tiles: <SettingsTile>[
              SettingsTile.navigation(
                leading: Icon(Icons.language),
                title: Text('Language'),
                value: Text('English'),
              ),
              SettingsTile.switchTile(
                onToggle: (value) async {
                  liveTrackingToggle = value;
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  prefs.setBool('liveTrackingToggle', value);
                  setState(() {});
                },
                initialValue: liveTrackingToggle,
                leading: Icon(Icons.location_city),
                title: Text('Maps live tracking'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
