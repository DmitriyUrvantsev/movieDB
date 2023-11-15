import 'package:flutter/material.dart';
import '../ui/widgets/auth/auth_widget.dart';
import '../ui/widgets/auth/auth_widget_model.dart';
import '../ui/widgets/my_screen/main_screen_widget.dart';
import '../ui/widgets/my_screen/movie_details/movie_details_widget.dart';
import '../ui/widgets/my_screen/movie_trailers/movie_details_trailer_widger.dart';

abstract class MainNavigationRoutsName {
  static const auth = 'auth';
  static const mainScreen = '/';
  static const movieScreen = '/movie';
  static const movieScreenDetails = '/movie_details';
  static const movieScreenDetailsTrailer = '/movie_details/trailer';
}

class MainNavigation {
  String initialRoute(bool isAuth) => isAuth
      ? MainNavigationRoutsName.mainScreen
      : MainNavigationRoutsName.auth;

  final routes = <String, Widget Function(BuildContext)>{
    MainNavigationRoutsName.auth: (context) => AuthWidgetModelProvider(
        model: AuthWidgetModel(), child: const AuthWidget()),
    MainNavigationRoutsName.mainScreen: (context) => const MainScreenWidget(),
  };

//----------------наша функция где можно передать arg ---------------------------------
  Route<Object> onGenerateRoutes(RouteSettings settings) {
    //! в main добавить!!!!!!!!!!

    switch (settings.name) {
      case MainNavigationRoutsName.movieScreenDetails:
        final movieId = settings.arguments as int;
        return MaterialPageRoute(
            builder: (context) => MovieDetailsWidget(
                  movieId: movieId,
                ));
      //----------------//
      case MainNavigationRoutsName.movieScreenDetailsTrailer:
        final arguments = settings.arguments;
        final youTubeKey = arguments is String ? arguments : '0';
        return MaterialPageRoute(
            builder: (context) => MovieDetailsTrailerWidget(
                  youTubeKey: youTubeKey,
                ));
      default:
        const widget = Text('Navigation Error');
        return MaterialPageRoute(builder: (context) => widget);
    }
  }
}
