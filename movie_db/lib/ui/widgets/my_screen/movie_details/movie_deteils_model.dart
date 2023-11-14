// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:movie_db_hard/domain/api_client/api_client.dart';

import '../../../../domain/data_providers/session_data_provider.dart';
import '../../../../domain/entity/movie_details.dart';
import '../../../../navigations/main_navigations.dart';

class MovieDetailsModel extends ChangeNotifier {
  final _apiClient = ApiClient();
  final _sessionDataProvider = SessionDataProvider();

  Future<void> Function()? onSessionExpired;
  //!функция для выброса на главную при истечении sessionId

  int movieId;
  String _locale = '';
  late DateFormat _dateFormat;
  MovieDetails? _movieDetails;
  MovieDetails? get movieDetails => _movieDetails;

  bool _isFavorite = false;
  bool get isFavorite => _isFavorite;

  MovieDetailsModel(
    this.movieId,
  ) {
    setupLocale;
  }
//?-------------------------

  List settupCrew() {
    final crew = _movieDetails?.credits?.crew?.toList();
    final mapCrew = [];
//----------------------------------
    var nameDirector = 'Отсутсвует';
    for (var i = 0; i <= crew!.length - 1; i++) {
      if (crew[i].job != null) {
        if (crew[i].job!.toLowerCase().contains('Director'.toLowerCase())) {
          nameDirector = crew[i].name!;
          break;
        }
      }
    }
    final director = {'Director': nameDirector};
    mapCrew.add(director);
//----------------------------------
    var nameProducer = 'Отсутсвует';
    for (var i = 0; i <= crew.length - 1; i++) {
      if (crew[i].job != null) {
        if (crew[i].job!.toLowerCase().contains('Producer'.toLowerCase())) {
          nameProducer = crew[i].name!;
          break;
        }
      }
    }
    final producer = {'Producer': nameProducer};
    mapCrew.add(producer);
//----------------------------------
    var nameEditor = 'Отсутсвует';
    for (var i = 0; i <= crew.length - 1; i++) {
      if (crew[i].job != null) {
        if (crew[i].job!.toLowerCase().contains('Editor'.toLowerCase())) {
          nameEditor = crew[i].name!;
          break;
        }
      }
    }
    final editor = {'Editor': nameEditor};
    mapCrew.add(editor);
//----------------------------------

    var nameDesign = 'Отсутсвует';
    for (var i = 0; i <= crew.length - 1; i++) {
      if (crew[i].job != null) {
        if (crew[i].job!.toLowerCase().contains('Design'.toLowerCase())) {
          nameDesign = crew[i].name!;
          break;
        }
      }
    }
    final design = {'Design': nameDesign};
    mapCrew.add(design);
//----------------------------------

    return mapCrew;
  }
//?-------------------------

//!-----------------------------
//!-----------------------------
  String stringFromDate(DateTime? date) =>
      date != null ? _dateFormat.format(date) : '';

//!-----------------------------
//!-----------------------------
  void setupLocale(BuildContext context) {
    //! нужно в MaterialApp прописать  localizationsDelegates:
    //! и поменять  в ios/Runner.xcworkspace добавить локаль и в андроиде тоже ПОЛУЧАЕТСЯ
    final locale = Localizations.localeOf(context).toLanguageTag();
    //берем текущую локаль, которая выставлена в телефоне
    if (_locale == locale) return;
    _locale = locale;
    //назначаем локаль взятой из настроек телефона
    _dateFormat =
        DateFormat.yMd('en-US'); //- чтобы была дробь(тк в русской точки)
    //_locale); //!для этого нужно подгрузить import 'package:intl/intl.dart';
    //назначаем локаль для формата даты

    loadMovieDetails(); //!ВОТ ИНТЕРЕСНО КАК СДЕЛАЛ ЖЕНЯ, N&R& когда локаль не изменилась return и соответственно загрузки нет
  }
// -----------------------

  Future<void> loadMovieDetails() async {
    try {
      _movieDetails =
          await _apiClient.getMovieDetails(locale: _locale, movieId: movieId);
      _checkFavorit();
      notifyListeners();
    } on ApiClientExeption catch (e) {
      _handleApiClientExeption(e);
    }
  }

//--------------------------
  void showTrailer(context) {
    //await _loadMovieDetails(locale, movieId);
    var youTubeKey = '0';
    //var youTubeName = 'name';
    if (_movieDetails?.videos?.results != null) {
      if (_movieDetails!.videos!.results!.isNotEmpty) {
        youTubeKey = _movieDetails!.videos!.results!.first?.key ?? '0';
        //youTubeName = _movieDetails!.videos!.results!.first?.name ?? '0';
      }
    }

    if (youTubeKey != '0') {
      Navigator.of(context).pushNamed(
          MainNavigationRoutsName.movieScreenDetailsTrailer,
          arguments: youTubeKey);
    }
  }

//?-------------------------------------
//?-------------------------------------
  Future<void> _checkFavorit() async {
    final sessionId = await _sessionDataProvider.getSessionId();
    if (sessionId == null) {
      return;
    }
    _isFavorite = await _apiClient.getChekIsFavorite(
        sessionId: sessionId, movieId: movieId);
    notifyListeners();
  }
  //----------------------------------

  Future<void> toglleIsFavorit() async {
    final sessionId = await _sessionDataProvider.getSessionId();
    final accountId = await _sessionDataProvider.getAccountId();

    _isFavorite = !_isFavorite;

    // if (sessionId == null || accountId == null) {
    //   return;
    // }
    try {
      await _apiClient.toglleFavorite(
          accountId: accountId ?? '0',
          sessionId: sessionId ?? '0',
          movieId: movieId,
          isFavorite: isFavorite,
          mediaType: MediaType.movie);
      notifyListeners();
    } on ApiClientExeption catch (e) {
      _handleApiClientExeption(e); //обработка ошибки
    }
  }

  //?-------------------------------------
  void _handleApiClientExeption(ApiClientExeption exeption) {
    switch (exeption.type) {
      case ApiClientExeptionType.sessionExpired:
        onSessionExpired?.call(); //! вызов функции на выброс при разлогинивании
        break;
      default: //! это плохо. Типа нужно было обработать остальные ошибки, но они тут не могут произойти
      //  print(exeption);
    }
  }

//?-------------------------------------
//?-------------------------------------

  // void closeTrailer(context) {
  //   Navigator.of(context).pop();
  // }
}

//!-------------------------------------------
//!-------------------------------------------
//!-------------------------------------------
//!-------------------------------------------
//!-------------------------------------------
//!-------------------------------------------
class MovieDetailsModelProvider extends InheritedNotifier<MovieDetailsModel> {
  final MovieDetailsModel model;
  const MovieDetailsModelProvider(
      {Key? key, required this.model, required Widget child})
      : super(
          key: key,
          notifier: model,
          child: child,
        );

  static MovieDetailsModelProvider? watch(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<MovieDetailsModelProvider>();
    //?.notifier;
  }

  static MovieDetailsModelProvider? read(BuildContext context) {
    final widget = context
        .getElementForInheritedWidgetOfExactType<MovieDetailsModelProvider>()
        ?.widget;
    return widget is MovieDetailsModelProvider
        ? widget
        : null; //                   .notifier : null;
  }

  // @override
  //bool updateShouldNotify(MainScreenModelProvider oldWidget) {
  //  return notifier != oldWidget.notifier;
}
