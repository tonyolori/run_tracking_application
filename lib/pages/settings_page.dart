import 'package:fit_work/pages/user_page.dart';
import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../auth.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    getBoolValuesSF();
  }

  Future<void> signout() async {
    await Auth().signOut();
  }

  Widget _title() {
    return const Text('Firebase Auth');
  }

  Widget _signOutButton() {
    return ElevatedButton(
      onPressed: signout,
      child: const Text('Sign Out'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SettingsList(
        sections: [
          SettingsSection(
            title: const Text('Common'),
            tiles: <SettingsTile>[
              SettingsTile(
                title: const Text('Profile'),
                onPressed: (context) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const UserPage()));
                },
              ),
              SettingsTile.navigation(
                leading: const Icon(Icons.language),
                title: const Text('Language'),
                value: const Text('English'),
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
                leading: const Icon(Icons.location_city),
                title: const Text('Maps live tracking'),
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
                leading: const Icon(Icons.location_city),
                title: const Text('Maps live tracking'),
              ),
            ],
          ),
          SettingsSection(
            title: Text('Account'),
            tiles: <SettingsTile>[
              SettingsTile.navigation(
                leading: Icon(Icons.language),
                title: Text('Language'),
                value: Text('English'),
              ),
              SettingsTile(
                onPressed: (context) {
                  signout();
                },
                leading: Icon(Icons.logout),
                title: Text('Sign Out'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
