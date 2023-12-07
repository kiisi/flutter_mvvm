import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../resources/strings_manager.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(AppStrings.settings),
    );
  }
}
