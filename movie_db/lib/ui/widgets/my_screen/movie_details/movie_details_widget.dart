import 'package:flutter/material.dart';
import 'package:movie_db_hard/ui/widgets/my_screen/movie_details/movie_details_sceleton.dart';
import '../../../../main_model.dart';
import 'movie_details_main_info_widget.dart';
import 'movie_details_model.dart';
import 'series_cast_widget.dart';

class MovieDetailsWidget extends StatefulWidget {
  final int movieId;
  const MovieDetailsWidget({
    Key? key,
    required this.movieId,
  }) : super(key: key);

  @override
  State<MovieDetailsWidget> createState() => _MovieDetailsWidgetState();
}

class _MovieDetailsWidgetState extends State<MovieDetailsWidget> {
  late final MovieDetailsModel _model;
  @override
  void initState() {
    super.initState();
    _model = MovieDetailsModel(widget.movieId);
    final appModel = MyAppModelProvider.read(context)
        ?.model; //привязка к ГЛАВНОЙ(корневой)модели
    if (appModel != null) {
      _model.onSessionExpired = () => appModel.ressetSession(context);
      //!связка функций ДВУХ моделей по разлогиниванию
      //? по идее так(в этом месте) делать не правильно - нужно делать через ЗАВИСИМОСТИ
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final model = MovieDetailsModelProvider.read(context)?.model;
    if (model?.movieDetails == null) {
      _model.setupLocale(context);
      // при первом запуске или смене локали - обновление локали и фильмов
    }
  }

  @override
  Widget build(BuildContext context) {
    //final movie = MovieDetailsModelProvider.read(context)?.model.movieDetails;

    return MovieDetailsModelProvider(
        model: _model, child: const MovieDetailsBodyWidget());
  }
}

class MovieDetailsBodyWidget extends StatelessWidget {
  const MovieDetailsBodyWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const TitleWidget()),
      backgroundColor: const Color.fromRGBO(46, 38, 39, 1),
      body: const ColoredBox(
        color: Color.fromRGBO(24, 23, 27, 1.0),
        child: BodyWidget(),
      ),
    );
  }
}
//!-----------------------------------------------------------------------------

class TitleWidget extends StatelessWidget {
  const TitleWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final movie = MovieDetailsModelProvider.watch(context)?.model.movieDetails;

    return Text(
      movie?.title ?? 'Загрузка...',
      style: const TextStyle(
          color: Colors.white, fontSize: 21, fontWeight: FontWeight.w700),
    );
  }
}

//?-----------------------------------------------------------------------------
class BodyWidget extends StatelessWidget {
  const BodyWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final movie = //null;
        MovieDetailsModelProvider.watch(context)?.model.movieDetails;

    if (movie == null) {
      return const MovieDetailsSceletonWidget();
    }
    return ListView(
      children: const [
        MovieDetailMainInfoWidget(),
        SeriesCastWidget(),
      ],
    );
  }
}

//?-----------------------------------------------------------------------------
//?-----------------------------------------------------------------------------
// ы
