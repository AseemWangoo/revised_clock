import 'dart:async' show Future;
import 'dart:io';
import 'dart:isolate' show ReceivePort, SendPort;
import 'dart:ui' show IsolateNameServer;

import 'package:flutter/material.dart' show debugPrint;

import 'package:android_alarm_manager/android_alarm_manager.dart';

class AlarmService {
  AlarmService();

  Future<bool> init({
    bool wakeup = false,
    DateTime startAt,
  }) async {
    if (!Platform.isAndroid) return false;

    if (_init) return _init;
    _init = true;

    bool init;
    try {
      init = await AndroidAlarmManager.initialize();
    } catch (ex) {
      debugPrint('Error in init ${ex.toString()}');
      return false;
    }
    if (!init) {
      debugPrint('Error in init:AndroidAlarmManager not initialize');
    }

    // Initialize the callback operation.
    _Callback.init();

    if (wakeup != null) _wakeup = wakeup;
    if (startAt != null) _startAt = startAt;

    return true;
  }

  static bool _init = false;

  static bool _wakeup = false;
  static DateTime _startAt;

  Future<bool> cancel(int id) async {
    bool cancel;
    try {
      cancel = await AndroidAlarmManager.cancel(id);
    } catch (ex) {
      cancel = false;
      debugPrint('Error in cancel ${ex.toString()}');
    }
    return cancel;
  }

  Future<bool> oneShot(
    Duration delay,
    int id,
    Function(int id) callback, {
    bool wakeup,
  }) async {
    assert(_init, "oneShot(): `AlarmManager.init()` must be first called.");
    if (!_init) {
      debugPrint('Error in oneShot ');
      return _init;
    }
    //
    bool oneShot = false;

    if (delay == null || delay.inMicroseconds == 0) {
      debugPrint('Error in oneShot `delay` is null or zero.');
      return oneShot;
    }

    if (id == null || id <= 0) {
      debugPrint('Error in oneShot`id` is null or less than or zero');
      return oneShot;
    }

    if (callback != null) _Callback.oneShots[id] = callback;

    try {
      oneShot = await AndroidAlarmManager.oneShot(
        delay,
        id,
        _Callback.oneShot,
        wakeup: wakeup ?? _wakeup,
      );
    } catch (ex) {
      oneShot = false;
      debugPrint('Error in oneShot ${ex.toString()}');
    }
    return oneShot;
  }

  Future<bool> periodic(
    Duration duration,
    int id,
    Function(int id) callback, {
    DateTime startAt,
    bool wakeup,
  }) async {
    assert(_init, "periodic(): `AlarmManager.init()` must be first called.");
    if (!_init) {
      debugPrint('Error in periodic init()` must be first called.');
      return _init;
    }

    bool periodic = false;

    if (duration == null || duration.inSeconds <= 0) {
      debugPrint('Error in periodic: `duration` is less than or zero.');
      return periodic;
    }

    if (id == null || id <= 0) {
      debugPrint('Error in periodic: `id` is less than or zero.');
      return periodic;
    }

    // Collect the Callback routine to eventually call.
    if (callback != null) _Callback.periodics[id] = callback;

    try {
      periodic = await AndroidAlarmManager.periodic(
        duration,
        id,
        _Callback.periodic,
        startAt: startAt ?? _startAt,
        wakeup: wakeup ?? _wakeup,
      );
    } catch (ex) {
      periodic = false;
      debugPrint('Error in periodic ${ex.toString()}');
    }
    return periodic;
  }
}

class _Callback {
  _Callback();

  static final ReceivePort _port = ReceivePort();

  static final Map<int, Function(int id)> oneShots = {};
  static final Map<int, Function(int id)> periodics = {};

  static void init() {
    _port.listen((map) {
      try {
        final int id = map.keys.first as int;
        final String type = map.values.first as String;

        Function(int id) func;
        switch (type) {
          case _oneShot:
            func = oneShots.remove(id);
            break;

          case _periodic:
            func = periodics[id];
        }
        func(id);
      } catch (ex) {
        debugPrint('Error in Callback init ${ex.toString()}');
      }
    });
  }

  static Future<void> oneShot(int id) async {
    final SendPort uiSendPort = IsolateNameServer.lookupPortByName(_oneShot);
    uiSendPort?.send({id: _oneShot});
  }

  static Future<void> periodic(int id) async {
    final SendPort uiSendPort = IsolateNameServer.lookupPortByName(_periodic);
    uiSendPort?.send({id: _periodic});
  }
}

const String _oneShot = 'oneShot';
const String _periodic = 'periodic';
