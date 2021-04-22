import 'package:flutter/material.dart';

import 'package:revised_clock/home/components/faces/clock_face.component.dart';
import 'package:revised_clock/home/view_models/time.viewmodel.dart';
import 'package:revised_clock/locator.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final timeViewModel = locator<TimeViewModel>();

    return Scaffold(
      appBar: AppBar(title: const Text('Clock')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            AnimatedBuilder(
              animation: timeViewModel,
              builder: (context, _) {
                return Text(timeViewModel.currentTime);
              },
            ),
            const ClockFaceComponent()
          ],
        ),
      ),
    );
  }
}
