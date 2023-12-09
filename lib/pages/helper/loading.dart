import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';

class LoadingPage extends StatelessWidget {
  final Widget nextScreen;

  const LoadingPage({Key? key, required this.nextScreen}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen.withScreenFunction(
      splash: Column(
          children: [Lottie.asset('assets/animations/loading_animation.json')]),
      screenFunction: () async {
        return nextScreen;
      },
      backgroundColor: Theme.of(context).colorScheme.background,
      splashIconSize: 300,
      duration: 3000,
      pageTransitionType: PageTransitionType.fade,
      splashTransition: SplashTransition.fadeTransition,
    );
  }
}

class BasicLoadingPage extends StatelessWidget {
  const BasicLoadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Lottie.asset('assets/animations/loading_animation.json')),
        backgroundColor: Theme.of(context).colorScheme.background);
  }
}
