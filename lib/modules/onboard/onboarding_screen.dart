import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../shared/components/components.dart';
import '../../shared/network/local/cash_helper.dart';
import '../login/shop_login_screen.dart';

class BoardingModel {
  final String image;
  final String title;
  final String body;

  BoardingModel({required this.image, required this.title, required this.body});
}

class OnBoardingScreen extends StatefulWidget {
  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  var boardingController = PageController();

  List<BoardingModel> boarding = [
    BoardingModel(
      image: 'assets/images/onboard_1.jpg',
      title: 'Welcome to Our App',
      body: 'This is the first onboarding screen.',
    ),
    BoardingModel(
      image: 'assets/images/onboard_1.jpg',
      title: 'Discover Features',
      body: 'Learn about the amazing features of our app.',
    ),
    BoardingModel(
      image: 'assets/images/onboard_1.jpg',
      title: 'Get Started',
      body: 'Let\'s get started with your journey!',
    ),
  ];
  bool isLast = false;

  void submit() {
    CashHelper.saveData(key: 'onboarding', value: true).then((value) {
      if (value) {
        navigateAndFinish(context, ShopLoginScreen());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          defaultTextButton(
            function: submit,
            text: "SKIP",
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                physics: BouncingScrollPhysics(),
                controller: boardingController,
                onPageChanged: (int index) {
                  if (index == boarding.length - 1) {
                    setState(() {
                      isLast = true;
                    });
                  } else {
                    setState(() {
                      isLast = false;
                    });
                  }
                },
                itemBuilder:
                    (context, index) => buildOnBoardingItem(boarding[index]),
                itemCount:
                    boarding.length, // Assuming you have 3 onboarding items
              ),
            ),
            SizedBox(height: 40.0),
            Row(
              children: [
                SmoothPageIndicator(
                  controller: boardingController,
                  count: boarding.length,
                  effect: ExpandingDotsEffect(
                    dotColor: Colors.grey,
                    activeDotColor: Colors.greenAccent,
                    dotHeight: 10,
                    expansionFactor: 4,
                    dotWidth: 10.0,
                    spacing: 5,
                  ),
                ),
                Spacer(),
                FloatingActionButton(
                  onPressed: () {
                    if (isLast)
                    {
                      submit();
                    } else {
                      boardingController.nextPage(
                        duration: Duration(milliseconds: 750),
                        curve: Curves.fastLinearToSlowEaseIn,
                      );
                    }
                  },
                  child: Icon(Icons.arrow_forward_ios),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildOnBoardingItem(BoardingModel model) => Container(
    decoration: BoxDecoration(
      color: Colors.white
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Image(
            image: AssetImage('${model.image}'),

            height: 300,
            width: double.infinity,
            fit: BoxFit.fill,
          ),
        ),
        SizedBox(height: 30),
        Text('${model.title}', style: TextStyle(fontSize: 24)),
        SizedBox(height: 15),
        Text('${model.body}', style: TextStyle(fontSize: 24)),
        SizedBox(height: 15),
      ],
    ),
  );
}
