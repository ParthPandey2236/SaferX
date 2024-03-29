import 'dart:async';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:circular_reveal_animation/circular_reveal_animation.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:saferx/Pages/One_on_One_Chat/ChatRoom.dart';
import 'Pages/assistant.dart';
import 'Pages/feed.dart';
import 'Pages/location.dart';
import 'Pages/profile.dart';

int a=0;
class nav_bar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Animated Navigation Bottom Bar'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  var _bottomNavIndex = 0; //default index of first screen
  AnimationController _animationController;
  Animation<double> animation;
  CurvedAnimation curve;

  final iconList = <IconData>[
    Icons.dynamic_feed,
    Icons.chat,
    Icons.location_on,
    FlutterIcons.face_profile_mco,
  ];

  final defaultTheme = SystemUiOverlayStyle.light.copyWith(
    systemNavigationBarColor: Colors.black,
    systemNavigationBarIconBrightness: Brightness.light,
  );

  @override
  void initState() {
    super.initState();
    final systemTheme = SystemUiOverlayStyle.light.copyWith(
      systemNavigationBarColor: Colors.purple,
      systemNavigationBarIconBrightness: Brightness.light,
    );
    SystemChrome.setSystemUIOverlayStyle(systemTheme);

    _animationController = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    );
    curve = CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        0.5,
        1.0,
        curve: Curves.fastOutSlowIn,
      ),
    );
    animation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(curve);

    Future.delayed(
      Duration(seconds: 1),
      () => _animationController.forward(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        assistant(),
        if(a==0)
        Scaffold(
          extendBody: true,
          resizeToAvoidBottomInset: false,
          body: Stack(
            children: <Widget>[
              _bottomNavIndex == 0
                  ? Feed()
                  : _bottomNavIndex == 1
                      ? ChatRoom()
                      : _bottomNavIndex == 2
                          ? location()
                          : _bottomNavIndex == 3
                              ? profile()
                              : Container(
                                  color: Colors.purple,
                                  child: Text('AN ERROR OCCURRED',
                                      style: TextStyle(fontSize: 18)),
                                ),
            ],
          ),
          floatingActionButton: ScaleTransition(
            scale: animation,
            child: FloatingActionButton(
              elevation: 8,
              backgroundColor: Colors.black54,
              child: IconButton(
                  icon: Icon(FlutterIcons.google_assistant_mco),
                  color: Colors.white,
                  onPressed: () {
                    setState(() {
                      a = 1;
                      SystemChrome.setSystemUIOverlayStyle(defaultTheme);
                    });
                  }),
              onPressed: () {
                _animationController.reset();
                _animationController.forward();
              },
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
          bottomNavigationBar: AnimatedBottomNavigationBar(
            icons: iconList,
            backgroundColor: Colors.purple,
            activeIndex: _bottomNavIndex,
            activeColor: Colors.black,
            splashColor: Colors.black,
            inactiveColor: Colors.white,
            notchAndCornersAnimation: animation,
            splashSpeedInMilliseconds: 300,
            notchSmoothness: NotchSmoothness.defaultEdge,
            gapLocation: GapLocation.center,
            leftCornerRadius: 32,
            rightCornerRadius: 32,
            onTap: (index) => setState(() => _bottomNavIndex = index),
          ),
        ),
      ],
    );
  }
}

class NavigationScreen extends StatefulWidget {
  final IconData iconData;

  NavigationScreen(this.iconData) : super();

  @override
  _NavigationScreenState createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen>
    with TickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> animation;

  @override
  void didUpdateWidget(NavigationScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.iconData != widget.iconData) {
      _startAnimation();
    }
  }

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );
    animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );
    _controller.forward();
    super.initState();
  }

  _startAnimation() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );
    animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.white,
      child: Center(
        child: CircularRevealAnimation(
          animation: animation,
          centerOffset: Offset(80, 80),
          maxRadius: MediaQuery.of(context).size.longestSide * 1.1,
          child: Icon(
            widget.iconData,
            color: HexColor('#FFA400'),
            size: 160,
          ),
        ),
      ),
    );
  }
}

class HexColor extends Color {
  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));

  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF' + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }
}
