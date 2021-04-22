import 'package:get_it/get_it.dart';

import 'home/view_models/clock_mode.viewmodel.dart';
import 'home/view_models/time.viewmodel.dart';
import 'shared/services/navigation.service.dart';

final GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => NavigationService());

  locator.registerLazySingleton(() => ClockModeViewModel());
  locator.registerLazySingleton(() => TimeViewModel());
}
