import 'package:chat/signin.dart';
import 'package:chat/signup.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class On_Boarding_Model {
  late final String image;
  late final String title;
  late final String body;

  On_Boarding_Model({
    required this.image,
    required this.title,
    required this.body,
  });
}

class OnBoardingScreen extends StatefulWidget {
  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  var boardController = PageController();

  List<On_Boarding_Model> boarding = [
    On_Boarding_Model(
      image: 'images/chat1.png',
      title: 'Looking For Items',
      body:
          'Our new service makes it easy for you to \n work anywhere, there are new features\n will really help you. ',
    ),
    On_Boarding_Model(
      image: 'images/conversation.png',
      title: 'Make a Payment',
      body:
          'Our new service makes it easy for you to \n work anywhere, there are new features\n will really help you. ',
    ),
    On_Boarding_Model(
      image: 'images/live-chat.png',
      title: 'Send items',
      body:
          'Our new service makes it easy for you to \n work anywhere, there are new features\n will really help you. ',
    ),
  ];

  bool isLast = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        actions: [
          TextButton(
            onPressed: () {
              onSubmit();
            },
            child: const Text(
              'SKIP',
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Get Started',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 8, bottom: 20),
              child: Text(
                'Start with signing up or sign in',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            Expanded(
              child: PageView.builder(
                physics: const BouncingScrollPhysics(),
                controller: boardController,
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
                itemBuilder: (context, index) =>
                    buildOnBoardingItem(boarding[index]),
                itemCount: boarding.length,
              ),
            ),
            SmoothPageIndicator(
              controller: boardController,
              effect: const ExpandingDotsEffect(
                dotColor: Colors.grey,
                activeDotColor: Colors.blue,
                dotHeight: 10,
                dotWidth: 10,
                expansionFactor: 4,
                spacing: 5.0,
              ),
              count: boarding.length,
            ),
            const SizedBox(
              height: 60,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (c) {
                  return const SignupScreen();
                }));
              },
              child: const Text('Sign up'),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (c) {
                    return const SigninScreen();
                  }));
                },
                child: const Text('Sign in')),
          ],
        ),
      ),
    );
  }

  Widget buildOnBoardingItem(On_Boarding_Model model) => Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Image(
              image: AssetImage('${model.image}'),
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(
            height: 30.0,
          )
        ],
      );

  onSubmit() {
    Navigator.push(context, MaterialPageRoute(builder: (c) {
      return const SignupScreen();
    }));
  }
}
