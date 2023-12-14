import 'package:decision_making/Google_Ads/interstitial_ads.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:horizontal_picker/horizontal_picker.dart';
import 'package:provider/provider.dart';

import '../../../Model/argument.dart';
import '../../../Model/decision.dart';

class AddArgument extends StatefulWidget {
  const AddArgument({
    Key? key,
    required this.decision,
    required this.notifyParent,
  }) : super(key: key);

  final Decision decision;
  final VoidCallback notifyParent;

  @override
  State<AddArgument> createState() => _AddArgumentState();
}

class _AddArgumentState extends State<AddArgument> {
  int? _score;

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

  late TextEditingController _nameController;

  bool isDark = GetStorage().read('isDarkMode') ?? false;

  @override
  void initState() {
    _score = 0;
    _nameController = TextEditingController();
    InterstitialAdsUtils.createInterstitialAd();
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    InterstitialAdsUtils.disposeInterstitialAd();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        SizedBox(
          height: size.height * 0.08,
          width: size.width,
          child: HorizontalPicker(
            backgroundColor: Get.isDarkMode ? Colors.grey[900]! : Colors.white,
            minValue: -10,
            maxValue: 10,
            divisions: 20,
            showCursor: true,
            activeItemTextColor:
                Get.isDarkMode ? Colors.white : Colors.grey[800]!,
            passiveItemsTextColor: Get.isDarkMode ? Colors.grey : Colors.grey,
            onChanged: (value) {
              setState(() {
                _score = (value + .5).floor();
              });
            },
            height: size.height * 0.08,
          ),
        ),
        Row(
          children: [
            Expanded(
                child: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  counterText: "",
                  hintText: 'Enter new argument',
                  border: InputBorder.none,
                ),
                cursorColor: isDark ? Colors.white : Colors.black,
                maxLength: 40,
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
                if (_nameController.text.isEmpty) {
                  return;
                }
                widget.decision.arguments!.add(Argument(
                  name: _nameController.text,
                  score: _score!.toDouble(),
                  date: DateTime.now(),
                ));
                Decision.getScore(widget.decision);
                widget.decision.save();
                _nameController.clear();
                setState(() {});
                FocusManager.instance.primaryFocus?.unfocus();
                widget.notifyParent();
                incrementInterstitialAdsCounter();
              },
            ),
          ],
        )
      ],
    );
  }
}
