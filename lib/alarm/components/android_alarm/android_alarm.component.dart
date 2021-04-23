import 'package:flutter/material.dart';

import 'package:hive/hive.dart';

import 'package:revised_clock/alarm/components/text/text.component.dart';
import 'package:revised_clock/alarm/models/alarm_time.model.dart';
import 'package:revised_clock/alarm/utils/strings.dart';
import 'package:revised_clock/home/components/button/button.component.dart';

import 'package:revised_clock/home/view_models/time.viewmodel.dart';
import 'package:revised_clock/locator.dart';
import 'package:revised_clock/shared/services/alarm/alarm.service.dart';
import 'package:revised_clock/shared/services/hive/hive.service.dart';

import 'package:hive_flutter/hive_flutter.dart';

class AndroidAlarmComponent extends StatefulWidget {
  const AndroidAlarmComponent({Key key}) : super(key: key);

  @override
  _AndroidAlarmComponentState createState() => _AndroidAlarmComponentState();
}

class _AndroidAlarmComponentState extends State<AndroidAlarmComponent> {
  final alarmSVC = locator<AlarmService>();
  final hiveSVC = locator<HiveService>();
  final timeViewModel = locator<TimeViewModel>().time;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(AlarmStrings.hour),
              const SizedBox(width: 10),
              TextComponent(
                initialVal: timeViewModel.hour.toString(),
                onChanged: (val) {},
              ),
              const SizedBox(width: 20),
              const Text(AlarmStrings.minute),
              const SizedBox(width: 10),
              TextComponent(
                initialVal: timeViewModel.minute.toString(),
                onChanged: (val) {},
              ),
            ],
          ),
          ButtonComponent(
            text: AlarmStrings.save,
            onPressed: () {
              final time = AlarmTime()
                ..hour = timeViewModel.hour.toString()
                ..minute = timeViewModel.minute.toString();

              final alarms = hiveSVC.getAlarms();
              alarms.add(time);
            },
          ),
          ValueListenableBuilder<Box<AlarmTime>>(
            valueListenable: hiveSVC.getAlarms().listenable(),
            builder: (context, value, _) {
              final list = value.values.toList();

              return ListView.builder(
                shrinkWrap: true,
                itemCount: list.length,
                itemBuilder: (context, int index) {
                  return Card(
                    child: ListTile(
                      leading: const Icon(Icons.alarm),
                      title: Row(
                        children: [
                          Text(list[index].hour),
                          const Text(":"),
                          Text(list[index].minute),
                        ],
                      ),
                      trailing: GestureDetector(
                        onTap: () async => list[index].delete(),
                        child: const Icon(Icons.delete),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
