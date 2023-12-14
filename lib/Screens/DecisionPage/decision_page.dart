import 'package:decision_making/Model/decision.dart';
import 'package:decision_making/Screens/DecisionPage/Widgets/arguments_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hive/hive.dart';
import 'package:lottie/lottie.dart';

import 'Widgets/add_argument.dart';
import 'Widgets/decision_gauge.dart';

class AddDecisionPage extends StatefulWidget {
  const AddDecisionPage({Key? key}) : super(key: key);

  @override
  State<AddDecisionPage> createState() => _AddDecisionPageState();
}

class _AddDecisionPageState extends State<AddDecisionPage> {
  late TextEditingController _nameController;
  bool isNewDecision = false;
  Decision? newDecisionState;

  bool isDark = GetStorage().read('isDarkMode') ?? false;

  void rebuild() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void initState() {
    _nameController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    if (newDecisionState!.isInBox) {
      newDecisionState!.save();
    }
    super.dispose();
  }

  _buildAppBar(Decision decision) {
    return AppBar(
      title: (decision.name!.isEmpty)
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
                          controller: _nameController,
                        ),
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          decision.name = _nameController.text;
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
                "Name your decision",
                style: TextStyle(fontSize: 18),
              ),
            )
          : Text(decision.name!),
      scrolledUnderElevation: 0,
      leading: GestureDetector(
        child: Icon(
          Icons.arrow_back_ios,
          color: isDark ? Colors.white : Colors.black,
        ),
        onTap: () async {
          if (newDecisionState!.arguments!.isEmpty &&
              newDecisionState!.name == "") {
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
                          newDecisionState!.delete();
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
                      controller: _nameController,
                    ),
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      decision.name = _nameController.text;
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
        IconButton(
          icon: const Icon(Icons.sort),
          onPressed: () {
            setState(() {
              decision.arguments!.sort((a, b) => a.score!.compareTo(b.score!));
            });
          },
        ),
        PopupMenuButton(
          itemBuilder: (context) {
            return const [
              PopupMenuItem(value: "order", child: Text("Restore Order")),
              PopupMenuItem(value: "delete", child: Text("Delete")),
            ];
          },
          onSelected: (value) {
            if (value == "order") {
              decision.arguments!.sort((a, b) => a.date!.compareTo(b.date!));
              rebuild();
            } else if (value == "delete") {
              decision.delete();
              Navigator.pop(context);
            }
          },
        )
      ],
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
          "No Arguments",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Text(
          "Add some arguments to get started",
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

  Widget _buildBody(BuildContext context, Decision decision) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: _buildAppBar(decision),
        body: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              (decision.arguments!.isEmpty)
                  ? _buildEmptyHolder()
                  : SingleChildScrollView(
                      physics: const ScrollPhysics(),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: SizedBox(
                              height: MediaQuery.of(context).size.height * 0.3,
                              width: MediaQuery.of(context).size.width,
                              child: DecisionGauge(decision: decision),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                left: 10.0,
                                right: 10.0,
                                bottom:
                                    MediaQuery.of(context).size.height * 0.15),
                            child: ArgumentsList(
                              decision: decision,
                            ),
                          ),
                        ],
                      ),
                    ),
              Positioned(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 0,
                right: 0,
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.16,
                  child: Material(
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                    color: isDark ? Colors.grey[800] : Colors.grey[200],
                    child: AddArgument(
                      decision: decision,
                      notifyParent: rebuild,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var arg = ModalRoute.of(context)!.settings.arguments;
    if (arg == null) {
      if (isNewDecision == false) {
        Decision decision =
            Decision(name: '', arguments: [], score: 0, date: DateTime.now());
        newDecisionState = decision;
        isNewDecision = true;
        final box = Hive.box<Decision>('decisions');
        box.add(decision);
      }
      return WillPopScope(
        onWillPop: () async {
          if (newDecisionState!.arguments!.isEmpty &&
              newDecisionState!.name == "") {
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
                          newDecisionState!.delete();
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
        child: _buildBody(context, newDecisionState!),
      );
    } else {
      arg = arg as Decision;
      newDecisionState = arg;
      return WillPopScope(
        onWillPop: () async {
          if (newDecisionState!.arguments!.isEmpty &&
              newDecisionState!.name == "") {
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
                          newDecisionState!.delete();
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
        child: _buildBody(context, newDecisionState!),
      );
    }
  }
}
