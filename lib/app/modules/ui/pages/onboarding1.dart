import 'package:elearning/app/controllers/theme/box_icons_icons.dart';
import 'package:elearning/app/data/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart'; // Make sure to import this package
import '../../auth/login.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({Key? key}) : super(key: key);

  @override
  _OnboardingState createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  final PageController controller = PageController(initialPage: 0);
  int pageNumber = 0;
  List<Widget> widgets = [];

  void createWidgets() {
    widgets.addAll([
      _buildPageContent(
        imagePath: 'assets/images/1.png',
        text: "Easy access to video lectures, & reading materials.",
      ),
      _buildPageContent(
        imagePath: 'assets/images/2.png',
        text: "Ask questions, earn coins and dominate the global leaderboard.",
      ),
      _buildLastPageContent(),
    ]);
  }

  Widget _buildPageContent({required String imagePath, required String text}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Image.asset(imagePath),
        Container(
          width: ResponsiveBreakpoints.of(context).isMobile
              ? MediaQuery.of(context).size.width * 0.8
              : MediaQuery.of(context).size.width * 0.6,
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Red Hat Display',
              fontSize: ResponsiveBreakpoints.of(context).isMobile ? 12 : 14,
              color: Color(0xFFFFFFFF),
            ),
          ),
        )
      ],
    );
  }

  Widget _buildLastPageContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Image.asset('assets/images/logo.png'),
        Container(
          width: MediaQuery.of(context).size.width * 0.6,
          child: Text(
            "E-Learn",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Red Hat Display',
              fontSize: 28,
              color: Color(0xFFFFFFFF),
            ),
          ),
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.2),
        Container(
          width: MediaQuery.of(context).size.width * 0.6,
          child: Text(
            "The complete E-learning solution for students of all ages!\n\n\nJoin for FREE now!",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Red Hat Display',
              fontSize: 14,
              color: Color(0xFFFFFFFF),
            ),
          ),
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.05),
        MaterialButton(
          color: Color(0xFFFFFFFF),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                "Login in ➡",
                style: TextStyle(
                  fontFamily: 'Red Hat Display',
                  fontSize: 16,
                  color: Color(0xFF0083BE),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => LoginPage()),
            );
          },
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    createWidgets();
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.kPrimary,
                  AppColors.kSecondary,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            child: Image.asset('assets/images/wave.png'),
          ),
          Align(
            alignment: Alignment.center,
            child: PageView.builder(
              controller: controller,
              onPageChanged: (value) {
                setState(() {
                  pageNumber = value;
                });
              },
              itemCount: widgets.length,
              itemBuilder: (context, index) => widgets[index],
            ),
          ),
          pageNumber == 2
              ? Container()
              : Positioned(
                  bottom: 10,
                  right: 10,
                  child: MaterialButton(
                    child: Icon(
                      pageNumber == 1
                          ? BoxIcons.bx_check
                          : BoxIcons.bx_chevron_right,
                      color: Color(0xFFFFFFFF),
                      size: 30,
                    ),
                    onPressed: () {
                      controller.nextPage(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.fastOutSlowIn,
                      );
                    },
                  ),
                ),
        ],
      ),
    );
  }
}
