import 'package:fit_work/pages/firebase_home.dart';
import 'package:fit_work/pages/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../auth.dart';


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
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ProfilePage()));
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
            ],
          ),
          SettingsSection(
            title: const Text('Account'),
            tiles: <SettingsTile>[
              SettingsTile(
                title: const Text('Firebase Settings'),
                onPressed: (context) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => FirebaseHomePage()));
                },
              ),
              SettingsTile(
                onPressed: (context) {
                  signout();
                },
                leading: const Icon(Icons.logout),
                title: const Text('Sign Out'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
