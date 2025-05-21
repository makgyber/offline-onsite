
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';


const Color _kAppColor = Color(0xFFFDDE6F);
const double _kSize = 100;

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context,) {
    return Center(
      child: LoadingAnimationWidget.twistingDots(
        leftDotColor: const Color(0xFF1A1A3F),
        rightDotColor: const Color(0xFFEA3799),
        size: _kSize,
      ),
    );
  }
}