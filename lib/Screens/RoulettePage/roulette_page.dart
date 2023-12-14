import 'dart:async';
import 'dart:math';

import 'package:decision_making/Google_Ads/interstitial_ads.dart';
import 'package:decision_making/Model/roulette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:glowstone/glowstone.dart';
import 'package:hive/hive.dart';
import 'package:lottie/lottie.dart';

class RoulettePage extends StatefulWidget {
  const RoulettePage({Key? key}) : super(key: key);

  @override
  State<RoulettePage> createState() => _RoulettePageState();
}

class _RoulettePageState extends State<RoulettePage> {
  bool isNewRoulette = false;
  Roulette? newRouletteState;

  late TextEditingController _nameTextFieldController;
  late TextEditingController _addTextFieldController;
  late StreamController<int> controller;

  bool isDark = GetStorage().read('isDarkMode') ?? false;

  int adsCounter = 0;
  void incrementInterstitialAdsCounter() {
    setState(() {
      adsCounter++;

      if (adsCounter >= 4) {
        InterstitialAdsUtils.showInterstitialAd();
        adsCounter = 0;
      }
    });
  }

  @override
  void initState() {
    _nameTextFieldController = TextEditingController();
    _addTextFieldController = TextEditingController();
    controller = StreamController<int>.broadcast();
    InterstitialAdsUtils.createInterstitialAd();
    super.initState();
  }

  @override
  void dispose() {
    controller.close();
    _nameTextFieldController.dispose();
    _addTextFieldController.dispose();
    if (newRouletteState!.isInBox) {
      newRouletteState!.save();
    }
    InterstitialAdsUtils.disposeInterstitialAd();
    super.dispose();
  }

  _buildAppBar(Roulette roulette) {
    return AppBar(
      title: (roulette.name!.isEmpty)
          ? GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text("Enter a new name"),
                    content: Material(
                      borderRadius: BorderRadius.circular(25),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 12.0),
                        child: TextField(
                          decoration: const InputDecoration(
                            counterText: "",
                            hintText: 'Enter new name',
                            border: InputBorder.none,
                          ),
                          controller: _nameTextFieldController,
                        ),
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          roulette.name = _nameTextFieldController.text;
                          //decision.save();
                          setState(() {});
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          "OK",
                          style: TextStyle(
                            color: isDark ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          "Cancel",
                          style: TextStyle(
                            color: isDark ? Colors.white : Colors.black,
                          ),
                        ),
                      )
                    ],
                  ),
                );
              },
              child: const Text(
                "Name your roulette",
                style: TextStyle(fontSize: 18),
              ),
            )
          : Text(roulette.name!),
      scrolledUnderElevation: 0,
      leading: GestureDetector(
        child: Icon(
          Icons.arrow_back_ios,
          color: isDark ? Colors.white : Colors.black,
        ),
        onTap: () async {
          if (newRouletteState!.choices!.isEmpty &&
              newRouletteState!.name == "") {
            await showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    content: Text(
                        'This roulette is empty, do you want to delete it?'),
                    actions: <Widget>[
                      TextButton(
                        child: Text('No'),
                        onPressed: () {
                          Navigator.of(context).pop(false);
                        },
                      ),
                      TextButton(
                        child: Text('Yes, delete'),
                        onPressed: () {
                          newRouletteState!.delete();
                          Get.back();
                          Get.back();
                        },
                      ),
                    ],
                  );
                });
          } else {
            Navigator.pop(context);
          }
        },
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.edit),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text("Enter a new name"),
                content: Material(
                  borderRadius: BorderRadius.circular(25),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: TextField(
                      decoration: const InputDecoration(
                        counterText: "",
                        hintText: 'Enter new name',
                        border: InputBorder.none,
                      ),
                      controller: _nameTextFieldController,
                    ),
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      roulette.name = _nameTextFieldController.text;
                      //decision.save();
                      setState(() {});
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      "OK",
                      style: TextStyle(
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      "Cancel",
                      style: TextStyle(
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                  )
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  _buildAddButton(Roulette roulette) {
    return Row(
      children: [
        Expanded(
            child: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: TextField(
            controller: _addTextFieldController,
            decoration: const InputDecoration(
              counterText: "",
              hintText: 'Enter new decision',
              border: InputBorder.none,
            ),
            cursorColor: isDark ? Colors.white : Colors.black,
            maxLength: 20,
            toolbarOptions: const ToolbarOptions(
              copy: true,
              cut: true,
              paste: true,
              selectAll: true,
            ),
          ),
        )),
        IconButton(
          icon: const Icon(Icons.save_rounded),
          onPressed: () async {
            if (_addTextFieldController.text.isEmpty) {
              return;
            }
            roulette.choices!.add(_addTextFieldController.text);
            setState(() {});
            _addTextFieldController.clear();
            roulette.selectedChoice = null;
            FocusManager.instance.primaryFocus?.unfocus();
            incrementInterstitialAdsCounter();
          },
        ),
      ],
    );
  }

  _buildFurtuneWheel(Roulette roulette) {
    Size size = MediaQuery.of(context).size;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Wheel of Fortune"),
          content: SizedBox(
            height: size.height * 0.6,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Spacer(),
                const Text(
                  "Spin the wheel to get your decision",
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(
                  height: size.height * 0.5,
                  width: size.width,
                  child: Padding(
                    padding: EdgeInsets.only(),
                    child: FortuneWheel(
                      indicators: [
                        FortuneIndicator(
                            alignment: Alignment.topCenter,
                            child: TriangleIndicator(
                              color:
                                  Get.isDarkMode ? Colors.green : Colors.green,
                            )),
                      ],
                      animateFirst: false,
                      physics: CircularPanPhysics(
                        duration: const Duration(seconds: 1),
                        curve: Curves.decelerate,
                      ),
                      onFling: () {
                        var rand = Random();
                        int randChoice;
                        setState(() {
                          if (roulette.choices!.length == 1) {
                            randChoice = rand.nextInt(5);
                            controller.add(randChoice);
                            if (randChoice % 2 == 0) {
                              roulette.selectedChoice = "yes";
                            } else {
                              roulette.selectedChoice = "no";
                            }
                          } else {
                            randChoice = rand.nextInt(roulette.choices!.length);
                            controller.add(randChoice);
                            roulette.selectedChoice =
                                roulette.choices![randChoice];
                          }
                        });
                      },
                      onAnimationEnd: () {
                        Future.delayed(const Duration(seconds: 2), () {
                          Navigator.pop(context);
                          FocusManager.instance.primaryFocus?.unfocus();
                        });
                      },
                      selected: controller.stream,
                      items: roulette.choices!.length == 1
                          ? const [
                              FortuneItem(child: Text("yes")),
                              FortuneItem(child: Text("no")),
                              FortuneItem(child: Text("yes")),
                              FortuneItem(child: Text("no")),
                              FortuneItem(child: Text("yes")),
                              FortuneItem(child: Text("no")),
                            ]
                          : roulette.choices!
                              .map(
                                (e) => FortuneItem(child: Text(e)),
                              )
                              .toList(),
                    ),
                  ),
                ),
                const Spacer(),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                FocusManager.instance.primaryFocus?.unfocus();
              },
              child: Text(
                "Cancel",
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                var rand = Random();
                int randChoice;
                setState(() {
                  if (roulette.choices!.length == 1) {
                    randChoice = rand.nextInt(5);
                    controller.add(randChoice);
                    if (randChoice % 2 == 0) {
                      roulette.selectedChoice = "yes";
                    } else {
                      roulette.selectedChoice = "no";
                    }
                  } else {
                    randChoice = rand.nextInt(roulette.choices!.length);
                    controller.add(randChoice);
                    roulette.selectedChoice = roulette.choices![randChoice];
                  }
                });
                FocusManager.instance.primaryFocus?.unfocus();
              },
              child: Text(
                "Spin",
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  _buildEmptyHolder() {
    Size size = MediaQuery.of(context).size;
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: size.width * 0.5,
          height: size.width * 0.5,
          child: Lottie.asset(
            "assets/animations/empty_box.json",
            frameRate: FrameRate(60),
            repeat: true,
          ),
        ),
        const Text(
          "No Decisions",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Text(
          "Add some decisions to get started",
          style: TextStyle(
            fontSize: 14,
          ),
        ),
        SizedBox(
          height: size.height * 0.2,
        )
      ],
    ));
  }

  _buildBody(BuildContext context, Roulette roulette) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: _buildAppBar(roulette),
        body: Stack(
          children: [
            (roulette.choices!.isEmpty)
                ? _buildEmptyHolder()
                : SizedBox(
                    width: size.width,
                    height: size.height,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: size.height * 0.3,
                          width: size.width,
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Center(
                              child: (roulette.selectedChoice == null)
                                  ? ElevatedButton(
                                      onPressed: () {
                                        _buildFurtuneWheel(roulette);
                                      },
                                      child: const Text("Try Your Luck"))
                                  : Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Spacer(),
                                          Glowstone(
                                            velocity: 2,
                                            radius: 20,
                                            color: Colors.purple,
                                            child: Text(
                                              roulette.selectedChoice!,
                                              style: const TextStyle(
                                                fontSize: 30,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          const Spacer(),
                                          Padding(
                                            padding: const EdgeInsets.all(8),
                                            child: ElevatedButton(
                                              onPressed: () {
                                                _buildFurtuneWheel(roulette);
                                              },
                                              child: const Text("Try Again"),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                            ),
                          ),
                        ),
                        Divider(
                          indent: size.width / 32,
                          endIndent: size.width / 32,
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(
                                left: 8.0,
                                right: 8.0,
                                bottom: size.height * 0.09),
                            child: ListView.builder(
                              itemCount: roulette.choices!.length,
                              itemBuilder: (context, index) {
                                return Dismissible(
                                  key: UniqueKey(),
                                  onDismissed: (direction) {
                                    roulette.choices!.removeAt(index);
                                    if (roulette.choices!.isEmpty) {
                                      roulette.selectedChoice = null;
                                    }
                                    setState(() {});
                                  },
                                  background: Container(
                                      alignment: Alignment.centerLeft,
                                      padding:
                                          const EdgeInsets.only(left: 20.0),
                                      color: Colors.red,
                                      child: const Icon(Icons.delete_rounded)),
                                  secondaryBackground: Container(
                                      alignment: Alignment.centerRight,
                                      padding:
                                          const EdgeInsets.only(right: 20.0),
                                      color: Colors.red,
                                      child: const Icon(Icons.delete_rounded)),
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: Text(
                                        roulette.choices![index],
                                        style: TextStyle(
                                          color: (roulette.choices![index] ==
                                                  roulette.selectedChoice)
                                              ? Colors.green
                                              : null,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
            Positioned(
              right: 0,
              left: 0,
              bottom: MediaQuery.of(context).viewInsets.bottom,
              child: SizedBox(
                height: size.height * 0.09,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Material(
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                    color: isDark ? Colors.grey[800] : Colors.grey[200],
                    child: _buildAddButton(roulette),
                  ),
                ),
              ),
            )
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    var arg = ModalRoute.of(context)!.settings.arguments;
    if (arg == null) {
      if (isNewRoulette == false) {
        Roulette roulette =
            Roulette(name: '', date: DateTime.now(), choices: []);
        newRouletteState = roulette;
        isNewRoulette = true;
        final box = Hive.box<Roulette>('roulettes');
        box.add(roulette);
      }
      return WillPopScope(
        onWillPop: () async {
          if (newRouletteState!.choices!.isEmpty &&
              newRouletteState!.name == "") {
            final value = await showDialog<bool>(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    content: Text(
                        'This roulette is empty, do you want to delete it?'),
                    actions: <Widget>[
                      TextButton(
                        child: Text('No'),
                        onPressed: () {
                          Navigator.of(context).pop(false);
                        },
                      ),
                      TextButton(
                        child: Text('Yes, delete'),
                        onPressed: () {
                          newRouletteState!.delete();
                          Navigator.of(context).pop(true);
                        },
                      ),
                    ],
                  );
                });
            return value == true;
          } else {
            return true;
          }
        },
        child: _buildBody(context, newRouletteState!),
      );
    } else {
      arg = arg as Roulette;
      newRouletteState = arg;
      return WillPopScope(
        onWillPop: () async {
          if (newRouletteState!.choices!.isEmpty &&
              newRouletteState!.name == "") {
            final value = await showDialog<bool>(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    content: Text(
                        'This roulette is empty, do you want to delete it?'),
                    actions: <Widget>[
                      TextButton(
                        child: Text('No'),
                        onPressed: () {
                          Navigator.of(context).pop(false);
                        },
                      ),
                      TextButton(
                        child: Text('Yes, delete'),
                        onPressed: () {
                          newRouletteState!.delete();
                          Navigator.of(context).pop(true);
                        },
                      ),
                    ],
                  );
                });
            return value == true;
          } else {
            return true;
          }
        },
        child: _buildBody(context, newRouletteState!),
      );
    }
  }
}
