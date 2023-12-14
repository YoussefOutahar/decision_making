import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:prefs/prefs.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final controller = LiquidController();

  bool isLastPage = false;

  Widget buildPage(
      {required Color color,
      required String imgUrl,
      required String description}) {
    return Container(
      color: color,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: SizedBox(
              height: MediaQuery.of(context).size.height / 2,
              width: MediaQuery.of(context).size.width / 1.2,
              child: SvgPicture.asset(
                imgUrl,
                height: MediaQuery.of(context).size.height / 2,
                width: MediaQuery.of(context).size.width / 3,
              ),
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: Text(
              description,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const Spacer(flex: 2),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            LiquidSwipe(
              enableLoop: false,
              liquidController: controller,
              onPageChangeCallback: (activePageIndex) {
                isLastPage = (activePageIndex == 2);
                setState(() {});
              },
              pages: [
                buildPage(
                  color: Colors.white,
                  description:
                      'Making decisions is an essential skill for many professions, but it’s also a skill that we need in our personal lives. We need to be able to make decisions not just for ourselves, but also for the people around us.',
                  imgUrl: 'assets/on_board/Yes or no-bro.svg',
                ),
                buildPage(
                  color: Colors.white,
                  description:
                      'Regardless, it is important to make decisions on your own. The first thing that you should do is to define the problem that you are trying to solve. You want to know why a decision is needed, what it will change about your life, and what’s important to you about the decision.',
                  imgUrl:
                      'assets/on_board/Starting a business project-amico.svg',
                ),
                buildPage(
                  color: Colors.white,
                  description:
                      'Welcome to the Decision Maker App. This app will help you make decisions in a fun and easy way. \nBased on Seymur Schulich\'s book "Get Smarter: Life and Business Lessons", this app is designed to help you make better decisions in your life through the use of the billionaires decision making techniques.',
                  imgUrl: 'assets/on_board/Business decisions-rafiki.svg',
                ),
              ],
            ),
            Positioned(
              right: 0,
              left: 0,
              bottom: 0,
              child: Row(
                  children: isLastPage
                      ? [
                          const Spacer(
                            flex: 2,
                          ),
                          AnimatedSmoothIndicator(
                            activeIndex: controller.currentPage,
                            count: 3,
                            effect: const WormEffect(
                              dotColor: Colors.grey,
                              activeDotColor: Colors.purple,
                            ),
                            onDotClicked: ((index) =>
                                controller.animateToPage(page: index)),
                          ),
                          const Spacer(),
                          TextButton(
                            onPressed: () async {
                              final prefs =
                                  await SharedPreferences.getInstance();
                              prefs.setBool("showHome", true);
                              Navigator.pushReplacementNamed(context, '/');
                            },
                            child: const Text("Get Started"),
                          )
                        ]
                      : [
                          TextButton(
                            onPressed: () {
                              controller.jumpToPage(page: 2);
                            },
                            child: const Text("Skip"),
                          ),
                          const Spacer(),
                          AnimatedSmoothIndicator(
                            activeIndex: controller.currentPage,
                            count: 3,
                            effect: const WormEffect(
                              dotColor: Colors.grey,
                              activeDotColor: Colors.purple,
                            ),
                            onDotClicked: ((index) =>
                                controller.animateToPage(page: index)),
                          ),
                          const Spacer(),
                          TextButton(
                            onPressed: () {
                              isLastPage = (controller.currentPage == 2);
                              debugPrint(
                                  (controller.currentPage + 1).toString());
                              controller.jumpToPage(
                                  page: controller.currentPage + 1);
                            },
                            child: const Text("Next"),
                          ),
                        ]),
            ),
          ],
        ),
      ),
    );
  }
}
