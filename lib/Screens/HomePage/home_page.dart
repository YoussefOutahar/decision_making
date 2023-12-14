import 'package:animated_segmented_tab_control/animated_segmented_tab_control.dart';
import 'package:decision_making/Google_Ads/banner_ads.dart';
import 'package:decision_making/Screens/HomePage/Widgets/roullets_list.dart';
import 'package:decision_making/Screens/onboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:prefs/prefs.dart';
import 'Widgets/decisions_list.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  late TabController tabController;

  bool isDark = GetStorage().read('isDarkMode') ?? false;
  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    BannerAdsUtils.initBannerAd();
    BannerAdsUtils.loadBannerAd();
    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    BannerAdsUtils.disposeBannerAd();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Future<SharedPreferences> f = SharedPreferences.getInstance();
    return FutureBuilder(
        future: f,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            bool showHome =
                (snapshot.data! as SharedPreferences).getBool("showHome") ??
                    false;

            if (showHome) {
              return Scaffold(
                appBar: AppBar(
                  automaticallyImplyLeading: false,
                  title: const Text('Decisions'),
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.settings),
                      onPressed: () {
                        Navigator.pushNamed(context, '/settings');
                      },
                    )
                  ],
                ),
                body: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: SegmentedTabControl(
                        indicatorColor: Colors.purple,
                        backgroundColor: !Get.isDarkMode
                            ? Colors.purple[200]
                            : Colors.grey[800],
                        splashHighlightColor: Theme.of(context).primaryColor,
                        controller: tabController,
                        tabs: const [
                          SegmentTab(label: "Decisions"),
                          SegmentTab(label: "Roulette"),
                        ],
                      ),
                    ),
                    const BannerAd(),
                    Expanded(
                      child: TabBarView(
                        controller: tabController,
                        children: const [
                          DecisionsList(),
                          RoulettesList(),
                        ],
                      ),
                    ),
                  ],
                ),
                floatingActionButton: FloatingActionButton(
                  backgroundColor: Colors.purple,
                  shape: const StadiumBorder(),
                  onPressed: () {
                    tabController.index == 0
                        ? Navigator.pushNamed(context, '/decision')
                        : Navigator.pushNamed(context, '/roulette');
                  },
                  child: const Icon(Icons.add),
                ),
              );
            } else {
              return OnBoardingScreen();
            }
          } else {
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        });
  }
}

class BannerAd extends StatefulWidget {
  const BannerAd({Key? key}) : super(key: key);

  @override
  State<BannerAd> createState() => _BannerAdState();
}

class _BannerAdState extends State<BannerAd> {
  @override
  void initState() {
    BannerAdsUtils.initBannerAd();
    BannerAdsUtils.loadBannerAd();
    super.initState();
  }

  @override
  void dispose() {
    BannerAdsUtils.disposeBannerAd();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BannerAdsUtils.buildBannerAd();
  }
}
