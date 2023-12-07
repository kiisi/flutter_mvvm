import 'dart:async';

import 'package:flutter/material.dart';

import '../../app/di.dart';
import '../../app/app_prefs.dart';
import '../resources/assets_manager.dart';
import '../resources/color_manager.dart';
import '../resources/routes_manager.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  final AppPreferences _appPreferences = instance<AppPreferences>();
  Timer? _timer;

  _startDelay() {
    _timer = Timer(const Duration(seconds: 2), _goNext);
  }

  _goNext() async {
    _appPreferences.isUserLoggedIn().then(
          (isUserLoggedIn) => {
            if (isUserLoggedIn)
              {Navigator.pushReplacementNamed(context, Routes.mainRoute)}
            else
              {
                _appPreferences
                    .isOnBoardingScreenViewed()
                    .then((isOnBoardingScreenViewed) => {
                          if (isOnBoardingScreenViewed)
                            {
                              Navigator.pushReplacementNamed(
                                  context, Routes.loginRoute)
                            }
                          else
                            {
                              Navigator.pushReplacementNamed(
                                  context, Routes.onBoardingRoute)
                            }
                        })
              }
          },
        );
  }

  @override
  void initState() {
    super.initState();
    _startDelay();
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.primary,
      body: const Center(
        child: Image(
          image: AssetImage(
            ImageAssets.splashLogo,
          ),
        ),
      ),
    );
  }
}
