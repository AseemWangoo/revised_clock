import 'package:flutter/material.dart';

import 'package:revised_clock/home/components/button/button.component.dart';
import 'package:revised_clock/home/components/faces/clock_face.component.dart';
import 'package:revised_clock/home/view_models/clock_mode.viewmodel.dart';
import 'package:revised_clock/home/view_models/time.viewmodel.dart';
import 'package:revised_clock/locator.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final clockModeVM = locator<ClockModeViewModel>();
    final timeViewModel = locator<TimeViewModel>();

    return Scaffold(
      appBar: AppBar(title: const Text('Clock')),
      body: Center(
        child: ValueListenableBuilder<ClockMode>(
          valueListenable: clockModeVM,
          builder: (context, value, child) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (value == ClockMode.digital)
                  AnimatedBuilder(
                    animation: timeViewModel,
                    builder: (context, _) {
                      return Text(
                        timeViewModel.currentTime,
                        style: Theme.of(context).textTheme.headline4,
                      );
                    },
                  )
                else
                  const ClockFaceComponent(),
                child,
              ],
            );
          },
          child: ButtonComponent(
            onPressed: () {
              final currVal = clockModeVM.value;

              if (currVal == ClockMode.analog) {
                clockModeVM.value = ClockMode.digital;
              } else {
                clockModeVM.value = ClockMode.analog;
              }
            },
          ),
        ),
      ),
    );
  }
}
