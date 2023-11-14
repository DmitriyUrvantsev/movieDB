import 'dart:async';

import 'package:flutter/material.dart';

import '../../../domain/api_client/api_client.dart';
import '../../../domain/data_providers/session_data_provider.dart';
import '../../../navigations/main_navigations.dart';

class AuthWidgetModel extends ChangeNotifier {
  final _sessionDataProvider = SessionDataProvider();
  final _apiClient = ApiClient();
  final loginController = TextEditingController(text: 'urvandimon');
  final passwordController = TextEditingController(text: 'movierfpfl1979');

  String? _errorText;
  String? get errorText => _errorText;

  bool _isAuthProgress = false;
  bool get canAuth => !_isAuthProgress;
  bool get isAuthProgress => _isAuthProgress;

  bool? _isAuthSecsess;
  bool? get isAuthSecsess => _isAuthSecsess;

  // Future<void> getMovie() async {//!по хорошему разобраться почему не работает
  //   await _apiClient.getPopularMovies(locale: 'en-US', page: 1);
  //   notifyListeners();
  //   print(',kz');
  // }

  //!------------------------------------------
  Future<void> auth(context) async {
    final login = loginController.text;
    final password = passwordController.text;
    //----------проверочки-------
    if (login.isEmpty || password.isEmpty) {
      //проверка на не заполлненость пароля
      _errorText = 'Заполните логин и пароль';
      notifyListeners(); //! выдает исключение
      return;
    }
    ////-------проверочки----------

    _errorText = null;
    _isAuthProgress = true; //блокировка на время авторизации
    notifyListeners(); //!выдает исключение

    String? sessionId; //обьявляем здесь
    int? accountId;
    try {
      sessionId = await _apiClient.auth(username: login, password: password);
      accountId = await _apiClient.getAccountID(sessionId: sessionId);
    } on ApiClientExeption catch (e) {
      switch (e.type) {
        case ApiClientExeptionType.network:
          _errorText =
              'Сервер не доступен. Проверьте подключение к интернету.\n'
              'Если Вы в России - подключите VPN!!!';
          break;
        case ApiClientExeptionType.auth:
          _errorText = 'Неверный логин или пароль';
          break;
        case ApiClientExeptionType.other:
          _errorText = 'Произошла ошибка попробуйте еще';
          break;
        case ApiClientExeptionType.sessionExpired:
          _errorText = 'Нужна повторная авторизация';
          break;
      }
    } catch (e) {
      _errorText = 'Произошла ошибка попробуйте еще';
    }
    _isAuthProgress = false; //разблокировка

//---проверочки
    if (_errorText != null) {
      notifyListeners();
      return;
    }
    if (sessionId == null) {
      //типа лишняя проверка
      _errorText = 'Неизвестная ошибка, повторите попытку';
      notifyListeners();
      return;
    }
////---проверочки

    await _sessionDataProvider.setSessionId(
        sessionId); //передача ключа в SessionDataProvider на хранение
    await _sessionDataProvider.setAccountId(accountId.toString());

    unawaited(Navigator.of(context)
        .pushReplacementNamed(MainNavigationRoutsName.mainScreen));
  }

  void resetPassword() {
    return;
  }
}

class AuthWidgetModelProvider extends InheritedNotifier<AuthWidgetModel> {
  final AuthWidgetModel model;
  const AuthWidgetModelProvider(
      {Key? key, required this.model, required Widget child})
      : super(
          key: key,
          notifier: model,
          child: child,
        );

  static AuthWidgetModelProvider? watch(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<AuthWidgetModelProvider>();
    //?.notifier;
  }

  static AuthWidgetModelProvider? read(BuildContext context) {
    final widget = context
        .getElementForInheritedWidgetOfExactType<AuthWidgetModelProvider>()
        ?.widget;
    return widget is AuthWidgetModelProvider
        ? widget
        : null; //                   .notifier : null;
  }

  // @override
  //bool updateShouldNotify(AuthWidgetModelProvider  oldWidget) {
  //  return notifier != oldWidget.notifier;
}
