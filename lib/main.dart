import 'package:decision_making/Model/argument.dart';
import 'package:decision_making/Model/decision.dart';
import 'package:decision_making/Model/roulette.dart';
import 'package:decision_making/Providers/themeHandling/theme_colors.dart';
import 'package:decision_making/Providers/themeHandling/theme_service.dart';
import 'package:decision_making/Screens/onboard_screen.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:prefs/prefs.dart';
import 'package:provider/provider.dart';

import 'Providers/settings_provider.dart';
import 'Screens/DecisionPage/decision_page.dart';
import 'Screens/HomePage/home_page.dart';
import 'Screens/RoulettePage/roulette_page.dart';
import 'Screens/settings_page.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Prefs.init();

  //Initialize Hive
  await Hive.initFlutter();

  //Register Hive Adapters
  Hive.registerAdapter(DecisionAdapter());
  Hive.registerAdapter(ArgumentAdapter());
  Hive.registerAdapter(RouletteAdapter());
  await Hive.openBox<Decision>('decisions');
  await Hive.openBox<Roulette>('roulettes');

  // Initialize Firebase.
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize the analytics service.
  FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  analytics.setAnalyticsCollectionEnabled(true);
  analytics.logAppOpen();

  //Initialize the ads service.
  MobileAds.instance.initialize();

  await GetStorage.init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<Settings>(create: (_) => Settings()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return GetMaterialApp(
      theme: ThemeColors.light,
      darkTheme: ThemeColors.dark,
      themeMode: ThemeService().theme,
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (BuildContext context) => const MyHomePage(),
        '/onboard': (BuildContext context) => const OnBoardingScreen(),
        '/decision': (BuildContext context) => const AddDecisionPage(),
        '/roulette': (BuildContext context) => const RoulettePage(),
        '/settings': (BuildContext context) => const SettingsPage(),
      },
      initialRoute: '/',
    );
  }
}
