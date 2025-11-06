import 'package:flutter/material.dart';
import 'package:tago_driver/presentation/common/appScaffold.dart';

class StatusView extends StatelessWidget {
  const StatusView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(body:
    Center(
      child: Text('Status Page', 
      style: TextStyle(
        color: Colors.white
      ),),
    )
    );
  }
}