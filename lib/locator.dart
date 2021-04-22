import 'package:get_it/get_it.dart';
import 'package:revised_clock/home/view_models/time.viewmodel.dart';

import 'shared/services/navigation.service.dart';

final GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => NavigationService());

  locator.registerLazySingleton(() => TimeViewModel());
}
