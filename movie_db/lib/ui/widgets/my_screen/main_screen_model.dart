import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:movie_db_hard/domain/api_client/api_client.dart';
import '../../../domain/entity/movie.dart';
import '../../../domain/entity/popular_movie_respons.dart';
import '../../../navigations/main_navigations.dart';

class MovieScreenModel extends ChangeNotifier {
  final _apiClient = ApiClient();
  final List<Movies?> _listMovies = [];
  List<Movies?> get listMovies =>
      List.unmodifiable(_listMovies); //! неизменяемый - unmodifiable
  String locale = '';
  late DateFormat _dateFormat;

  late int _carentPage;
  int _totalPage = 1;
  bool isProgressLoad = false;
  String? _serchQuery;
  Timer? _serchDeboubce;

  Future<void> Function()? onSessionExpired;
  //!функция для выброса на главную при истечении sessionId

  String stringFromDate(DateTime? date) =>
      date != null ? _dateFormat.format(date) : '';

//--------------
  void setupLocale(BuildContext context) {
    //! нужно в MaterialApp прописать  localizationsDelegates:
    //! и поменять  в ios/Runner.xcworkspace добавить локаль и в андроиде
    final local = Localizations.localeOf(context).toLanguageTag();
    if (locale == local) return;
    locale = local;
    _dateFormat = DateFormat.yMMMMd(
        locale); //!для этого нужно подгрузить import 'package:intl/intl.dart';
    _resetMovieList();
  }

  Future<void> _resetMovieList() async {
    _carentPage = 0; //?пагинация
    _totalPage = 1;
    _listMovies.clear();
    await _loadMovies();
  }

//--------------
  Future<PopularMovieRespons> _selectedLoading(
      String locale, int nextPage) async {
    final query = _serchQuery;

    if (query == null) {
      return await _apiClient.getPopularMovies(locale, nextPage);
    } else {
      return await _apiClient.getSerchMovies(
          locale: locale, page: nextPage, query: query);
    }
  }

  Future<void> _loadMovies() async {
    if (isProgressLoad || _carentPage >= _totalPage) return;
    isProgressLoad = true;
    final nextPage = _carentPage + 1; //?пагинация

    try {
      final moviesResponse = await _selectedLoading(locale, nextPage);
      _listMovies.addAll(moviesResponse.movies);

      _carentPage = moviesResponse.page; //?пагинация
      _totalPage = moviesResponse.total_pages; //?пагинация
      isProgressLoad = false;
      notifyListeners();
    } catch (e) {
      isProgressLoad =
          false; //! если будет ошибка, то там не сработает. ЗНАЧИТ ПРИ ОШИБКЕ БУДЕТ ЗДЕСЬ
    }
  }

  Future<void> serchMovies(String text) async {
    _serchDeboubce
        ?.cancel(); //!убирает промежуточные запросы оставляя последний
    _serchDeboubce = Timer(const Duration(milliseconds: 600), () async {
      final serchQuery =
          text.isNotEmpty ? text : null; //обновить если стирается запрос
      if (_serchQuery == serchQuery) return; //если запрос не изменился return
      _serchQuery = serchQuery;
      await _resetMovieList();
    });
  }

//--------------
  void onTapMovie(context, int movieId) async {
    Navigator.of(context).pushNamed(MainNavigationRoutsName.movieScreenDetails,
        arguments: movieId);
  }

  //--------------
  void showedMovieAtIndex(int index) {
    if (index < _listMovies.length - 1) return;
    if (_carentPage > _totalPage || isProgressLoad) return;

    _loadMovies();
  }
}

//!-------------------------------------------
//!-------------------------------------------
//!-------------------------------------------
class MovieScreenModelProvider extends InheritedNotifier<MovieScreenModel> {
  final MovieScreenModel model;
  const MovieScreenModelProvider(
      {Key? key, required this.model, required Widget child})
      : super(
          key: key,
          notifier: model,
          child: child,
        );

  static MovieScreenModelProvider? watch(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<MovieScreenModelProvider>();
    //?.notifier;
  }

  static MovieScreenModelProvider? read(BuildContext context) {
    final widget = context
        .getElementForInheritedWidgetOfExactType<MovieScreenModelProvider>()
        ?.widget;
    return widget is MovieScreenModelProvider ? widget : null;
  }
}
