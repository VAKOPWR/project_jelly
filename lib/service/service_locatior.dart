import 'package:get_it/get_it.dart';
import 'package:project_jelly/service/location_service.dart';

final serviceLocator = GetIt.instance;

void setUpServiceLocatior() {
  serviceLocator.registerSingleton<LocationService>(LocationService());
}
