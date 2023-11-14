import 'package:flutter/material.dart';
import 'package:movie_db_hard/navigations/main_navigations.dart';

import 'domain/data_providers/session_data_provider.dart';

class MyAppModel extends ChangeNotifier {
  final _sessionDataProvider = SessionDataProvider();

  bool _isAuth = false;
  bool get isAuth => _isAuth;

  Future<void> isChekAuth() async {
    final sessionId = await _sessionDataProvider.getSessionId();
    _isAuth = sessionId != null;
  }

  Future<void> ressetSession(BuildContext context) async {
    await _sessionDataProvider.setSessionId(null);
    await _sessionDataProvider.setAccountId(null);
    await Navigator.of(context).pushNamedAndRemoveUntil(
      MainNavigationRoutsName.auth,
      (route) => false, // false - закрытие всех экранов
      //? (route) => true,// true - закрытие не всех экранов(тина можно делать проверки)
      //! при разлогинивании будет обнуляться SessionId и AccountId
      //!и переход на авторизацию с закрытием всех предыдущих окон
    );
  }
}

class MyAppModelProvider extends InheritedNotifier<MyAppModel> {
  final MyAppModel model;
  const MyAppModelProvider(
      {Key? key, required this.model, required Widget child})
      : super(
          key: key,
          notifier: model,
          child: child,
        );

  static MyAppModelProvider? watch(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<MyAppModelProvider>();
    //?.notifier;
  }

  static MyAppModelProvider? read(BuildContext context) {
    final widget = context
        .getElementForInheritedWidgetOfExactType<MyAppModelProvider>()
        ?.widget;
    return widget is MyAppModelProvider
        ? widget
        : null; //                   .notifier : null;
  }

  // @override
  //bool updateShouldNotify(MyAppModelProvider oldWidget) {
  //  return notifier != oldWidget.notifier;
}
