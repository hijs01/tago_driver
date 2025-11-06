import 'package:flutter/material.dart';
import 'package:tago_driver/presentation/common/appScaffold.dart';

class SettingView extends StatelessWidget {
  const SettingView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: Center(
        child: Text('Setting View', style: TextStyle(color: Colors.white),),
      ),
    );
  }
}