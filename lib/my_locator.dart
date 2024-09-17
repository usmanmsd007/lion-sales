import 'package:get_it/get_it.dart';
import 'package:lion_sales/screens/home/bottom_nav_bar/bottom_nav_bloc.dart';

var locator = GetIt.instance;
initDependencies() {
  var bootmNavBloc = BottomNavBloc();
  locator.registerSingleton<BottomNavBloc>(bootmNavBloc);
}
