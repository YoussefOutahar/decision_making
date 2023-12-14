import 'package:decision_making/Model/decision.dart';
import 'package:decision_making/Model/roulette.dart';
import 'package:decision_making/Providers/settings_provider.dart';
import 'package:decision_making/Providers/themeHandling/theme_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:settings_ui/settings_ui.dart';
import '../Providers/themeHandling/theme_service.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    bool isDark = GetStorage().read('isDarkMode') ?? false;
    Settings settings = Provider.of<Settings>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: SettingsList(
        sections: [
          SettingsSection(
            title: const Text(
              "Appearance",
              style: TextStyle(color: Colors.purple),
            ),
            tiles: [
              SettingsTile.switchTile(
                activeSwitchColor: Colors.purple,
                title: const Text("Dark Mode"),
                leading: const Icon(Icons.dark_mode),
                initialValue: isDark,
                onToggle: (bool value) {
                  ThemeService().switchTheme();
                  isDark = GetStorage().read('isDarkMode');
                  setState(() {});
                },
              )
            ],
          ),
          SettingsSection(
            title: const Text(
              "Functionality",
              style: TextStyle(color: Colors.purple),
            ),
            tiles: [
              SettingsTile.switchTile(
                activeSwitchColor: Colors.purple,
                initialValue: settings.isShowingSums,
                onToggle: (value) {
                  settings.showSums(value);
                },
                title: const Text('Show arguments Sum'),
                leading: const Icon(Icons.calculate),
              ),
              SettingsTile(
                leading: const Icon(Icons.phone_android_rounded),
                title: const Text("Show Introduction Screen"),
                onPressed: (context) {
                  Navigator.pushReplacementNamed(context, '/onboard');
                },
              ),
              SettingsTile(
                title: const Text('Delete all decisions'),
                leading: const Icon(Icons.delete),
                onPressed: (BuildContext context) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Delete all decisions?'),
                        content: const Text(
                            'This will delete all decisions and arguments.'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              Hive.box<Decision>('decisions').clear();
                              Navigator.of(context).pop();
                            },
                            child: const Text('Delete'),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
              SettingsTile(
                title: const Text('Delete all roulettes'),
                leading: const Icon(Icons.delete),
                onPressed: (context) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Delete all decisions?'),
                        content: const Text(
                            'This will delete all decisions and arguments.'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              Hive.box<Roulette>('roulettes').clear();
                              Navigator.of(context).pop();
                            },
                            child: const Text('Delete'),
                          ),
                        ],
                      );
                    },
                  );
                },
              )
            ],
          ),
          SettingsSection(
            title: const Text(
              "About",
              style: TextStyle(color: Colors.purple),
            ),
            tiles: [
              SettingsTile(
                title: const Text("Version"),
                leading: const Icon(Icons.info),
                onPressed: (context) => showAboutDialog(
                  //Todo: Add version number
                  context: context,
                  applicationIcon: Image.asset(
                    Get.isDarkMode
                        ? 'assets/icon_launcher/white_icon.png'
                        : 'assets/icon_launcher/black_icon.png',
                    scale: 8,
                  ),
                  applicationName: 'Choice Maker',
                  applicationVersion: '1.0.0',
                  children: const [
                    Text(
                      'Based on Seymur Schulich\'s book "Get Smarter: Life and Business Lessons", this app is designed to help you make better decisions in your life through the use of the billionaires decision making techniques.',
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Developed by:',
                    ),
                    Text(
                      'Youssef Outahar',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
