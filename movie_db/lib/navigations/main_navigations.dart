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
  // final initialRoute =
  //     MainNavigationRoutsName.auth; //! в main добавить!!!!!!!!!!
  String initialRoute(bool isAuth) => isAuth
      ? MainNavigationRoutsName.mainScreen
      : MainNavigationRoutsName.auth;

  final routes = <String, Widget Function(BuildContext)>{
    //! в main добавить!!!!!!!!!!
    MainNavigationRoutsName.auth: (context) => AuthWidgetModelProvider(
        model: AuthWidgetModel(), child: const AuthWidget()),
    MainNavigationRoutsName.mainScreen: (context) => const MainScreenWidget(),
    // MainNavigationRoutsName.movieScreenDetails: (context) => const MovieDetailsWidget(),
  };

//----------------наша функция где можно передать arg ---------------------------------
  Route<Object> onGenerateRoutes(RouteSettings settings) {
    //! в main добавить!!!!!!!!!!

    switch (settings.name) {
      //будем проверять, что это за name

      case MainNavigationRoutsName
            .movieScreenDetails: // будем возвращать маршруты, см урок 59
        final movieId = settings.arguments as int;
        return MaterialPageRoute(
            builder: (context) => MovieDetailsWidget(
                  movieId: movieId,
                ));
      //----------------//
      case MainNavigationRoutsName
            .movieScreenDetailsTrailer: // будем возвращать маршруты, см урок 59
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
