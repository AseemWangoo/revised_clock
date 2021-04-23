import 'dart:io';

import 'package:flutter/material.dart';

import 'package:revised_clock/alarm/components/android_alarm/android_alarm.component.dart';
import 'package:revised_clock/alarm/utils/strings.dart';

class AlarmView extends StatelessWidget {
  const AlarmView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isAndroid = Platform.isAndroid;

    return Scaffold(
      appBar: AppBar(title: const Text(AlarmStrings.title)),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isAndroid)
              const AndroidAlarmComponent()
            else
              const Text('To Implement'),
            const AndroidAlarmComponent()
          ],
        ),
      ),
    );
  }
}
