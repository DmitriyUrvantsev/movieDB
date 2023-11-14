import 'package:flutter/material.dart';
import 'main_model.dart';
import 'navigations/main_navigations.dart';
import 'ui/theme/app_colors.dart';
import 'package:flutter_localizations/flutter_localizations.dart';


//! ДЛЯ УСПЕШНОЙ РАБОТЫ ПРИЛОЖЕНИЯ НЕОБХОДИМО ВКЛЮЧИТЬ VPN НА ВАШЕМ УСТРОЙСТВЕ

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final model = MyAppModel();
  await model
      .isChekAuth(); //приостанавливаем все и проверяем аторизованны лиии (await т.к. isChekAuth() асинхронный)
  final app = MyAppModelProvider(model: model, child: MyApp(model: model));
  runApp(app);
}

class MyApp extends StatelessWidget {
  final MyAppModel
      model; //авторизованы уже или нет(в зависимости от sessionId != null в моделе)
  static final mainNavigation = MainNavigation();

  const MyApp({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          appBarTheme:
              const AppBarTheme(backgroundColor: AppColors.mainDarkBlue),
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
              backgroundColor: AppColors.mainDarkBlue,
              selectedItemColor: Colors.white,
              unselectedItemColor: Colors.grey.shade700),
        ),
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('ru', 'RU'), // Russian
          Locale('en', 'US'), // English
        ],
        routes: mainNavigation.routes,
        // {
        //   '/': (context) => const AuthWidget(),
        //   '/main': (context) => const MainScreenWidget(),
        //   '/main/movie_details': (context) =>  MovieDetailsWidget(),
        // },
        initialRoute: mainNavigation.initialRoute(model.isAuth),
        //! если передавать через Провайдер ...(model?.isAuth==true) - непонятно///

        //   mainNavigation.initialRoute,
        //'/',
        onGenerateRoute: mainNavigation.onGenerateRoutes);
  }
}
