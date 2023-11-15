import 'package:flutter/material.dart';
import '../../../../domain/api_client/api_client.dart';
import 'movie_details_model.dart';

class MovieDetailMainInfoWidget extends StatelessWidget {
  const MovieDetailMainInfoWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _TopPosterWidget(),
        const Padding(
          padding: EdgeInsets.all(20.0),
          child: _MovieNameWidget(),
        ),
        const _ScoreWidget(),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 60),
          child: _SummeryWidget(),
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: _overviewWidget(),
        ),
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: DescriptionWidget(),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: _CastPersonWidget(),
        ),
      ],
    );
  }
}

//?-----------------------------------------------------------------------------
class _TopPosterWidget extends StatelessWidget {
  const _TopPosterWidget();

  @override
  Widget build(BuildContext context) {
    final model = MovieDetailsModelProvider.watch(context)?.model;
    final movie = MovieDetailsModelProvider.watch(context)?.model.movieDetails;
    final backdropPath = movie?.backdrop_path;
    final posterPath = movie?.poster_path;
    return AspectRatio(
      //!widget, чтобы не прыгал экран, когда будет грузиться Image, из-за SizedBox.shrink(),
      aspectRatio: 390 / 219, //!это пропорция, а не пиксели!!!
      child: Stack(
        children: [
          backdropPath != null
              ? Image.network(
                  ApiClient.imageUrl(backdropPath),
                  fit: BoxFit.fitWidth,
                  width: double.infinity,
                )
              : const SizedBox.shrink(),
          Positioned(
              top: 20,
              left: 20,
              bottom: 20,
              child: posterPath != null
                  ? Image.network(ApiClient.imageUrl(posterPath))
                  : const SizedBox.shrink()),
          Positioned(
              top: 10,
              right: 10,
              child: IconButton(
                  onPressed: () => model?.toglleIsFavorit(),
                  icon: Icon(
                    model?.isFavorite == false || model?.isFavorite == null
                        ? Icons.favorite_outline_outlined
                        : Icons.favorite,
                    color: Colors.red,
                  )))
        ],
      ),
    );
  }
}

//?-----------------------------------------------------------------------------
class _MovieNameWidget extends StatelessWidget {
  const _MovieNameWidget();

  @override
  Widget build(BuildContext context) {
    final movie = MovieDetailsModelProvider.watch(context)?.model.movieDetails;

    return Center(
      child: RichText(
          maxLines: 3,
          textAlign: TextAlign.center,
          text: TextSpan(
            children: [
              TextSpan(
                  text: movie?.title ?? '',
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 18)),
              TextSpan(
                  text: ' (${movie?.release_date?.year.toString() ?? '0'})',
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 14)),
            ],
          )),
    );
  }
}

//?-----------------------------------------------------------------------------
class _ScoreWidget extends StatelessWidget {
  const _ScoreWidget();

  @override
  Widget build(BuildContext context) {
    final model = MovieDetailsModelProvider.watch(context)?.model;
    final rating = MovieDetailsModelProvider.watch(context)
        ?.model
        .movieDetails
        ?.vote_average;
    final percent = rating != null ? rating / 10 : 0;
    final trailer = model?.movieDetails?.videos?.results;
    final chek = trailer == null || trailer.isEmpty;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        TextButton(
            onPressed: () {},
            child: Row(
              children: [
                SizedBox(
                  width: 40,
                  height: 40,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CircularProgressIndicator(
                          backgroundColor:
                              const Color.fromARGB(255, 25, 54, 31),
                          color: const Color.fromARGB(255, 37, 203, 103),
                          value: percent as double),
                      Text('${(percent * 100).ceil()}')
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                const Text('User Score'),
              ],
            )),
        //--------------------------------------
        Container(height: 15, width: 2, color: Colors.grey),
        //--------------------------------------
        if (!chek)
          TextButton.icon(
              onPressed: () => model?.showTrailer(context),
              icon: const Icon(Icons.play_arrow),
              label: const Text('Play Trailer')),
        if (chek)
          TextButton.icon(
            onPressed: () => {},
            icon: const Icon(Icons.play_arrow),
            label: Text(
              'Play Trailer',
              style: TextStyle(color: Colors.grey[800]),
            ),
            style: TextButton.styleFrom(iconColor: Colors.grey[800]),
          ),
      ],
    );
  }
}

//?-----------------------------------------------------------------------------
class _SummeryWidget extends StatelessWidget {
  const _SummeryWidget();

  @override
  Widget build(BuildContext context) {
    final model = MovieDetailsModelProvider.watch(context)?.model;
    final r = model?.movieDetails?.adult == false ? 'R' : '';
    final date = model?.movieDetails?.release_date;
    final productionCountries =
        model?.movieDetails!.production_countries?[0].isoProduction ?? '';
    final runTimeHour = model?.movieDetails?.runtime != null
        ? model!.movieDetails!.runtime! ~/ 60
        : 0;
    final runTimeMinutes = model?.movieDetails?.runtime != null
        ? model!.movieDetails!.runtime! % 60
        : 0;
    final genres =
        model?.movieDetails?.genres?.map((e) => e.name).toList().join(', ') ??
            '';

    return Center(
      child: Text(
        textAlign: TextAlign.center,
        '$r, ${model?.stringFromDate(date) ?? 'null'} ($productionCountries) ${runTimeHour}h${runTimeMinutes}m \n'
        '$genres ',
        maxLines: 3,
        style: const TextStyle(
            color: Colors.white, fontWeight: FontWeight.w500, fontSize: 16),
      ),
    );
  }
}

//?-----------------------------------------------------------------------------
Text _overviewWidget() {
  return const Text(
    'Overview',
    style: TextStyle(
        color: Colors.white, fontSize: 16, fontWeight: FontWeight.w400),
  );
}

//?-----------------------------------------------------------------------------
class DescriptionWidget extends StatelessWidget {
  const DescriptionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final overview = MovieDetailsModelProvider.watch(context)
            ?.model
            .movieDetails
            ?.overview ??
        '';

    return Text(
      overview,
      maxLines: 4,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(
          color: Colors.white, fontSize: 16, fontWeight: FontWeight.w400),
    );
  }
}

//?-----------------------------------------------------------------------------
class _CastPersonWidget extends StatelessWidget {
  const _CastPersonWidget();

  @override
  Widget build(BuildContext context) {
    //?-------------------------------------------------------------------
    final model = MovieDetailsModelProvider.watch(context)?.model;
    final mapCrew = model?.settupCrew();

    return SizedBox(
      height: 100,
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 8.0,
            crossAxisSpacing: 8.0,
            mainAxisExtent: 45),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        itemCount: mapCrew?.length ?? 0,
        itemBuilder: (context, index) {
          const textStyle = TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.w400);
          return Container(
            alignment: Alignment.centerLeft,
            child: Text(
              '${mapCrew?[index].keys.toList().join() ?? '0'} \n ${mapCrew?[index].values.toList().join() ?? '0'}',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: textStyle,
            ),
          );
        },
      ),
    );
  }
}
