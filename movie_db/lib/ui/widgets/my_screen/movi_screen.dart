// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:movie_db_hard/domain/api_client/api_client.dart';

import 'main_screen_model.dart';
import 'movie_screen_sceleton.dart';

class MovieWidget extends StatelessWidget {
  const MovieWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final watch = //null;
        MovieScreenModelProvider.watch(context)?.model;

    if (watch == null || watch.isProgressLoad == true) {
      return const MovieScreenSkeletonWidget(); //! проверка на нул, чтобы не париться ниже
    }

    return Stack(
      // Stack для TextFielda
      children: [
        ListView.builder(
          padding: const EdgeInsets.only(top: 65),
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior
              .onDrag, //!!!! скрывает клавиатуру
          itemCount: watch.listMovies.length,
          itemExtent: 162,
          itemBuilder: (BuildContext context, int index) {
            watch.showedMovieAtIndex(index);
            final movie = watch.listMovies[index];
            final posterPath = watch.listMovies[index]?.poster_path;
            final relisDate = movie?.release_date;
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              child: Stack(
                ///Stack для InkWell
                children: [
                  Container(
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: const Color.fromARGB(182, 68, 68, 68),
                        // width: 1.0,
                        // style: BorderStyle.solid,
                        // strokeAlign: BorderSide.strokeAlignInside
                      ),
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black45,
                          offset: Offset(0, 3),
                          blurRadius: 10,

                          //blurStyle: BlurStyle.normal
                        )
                      ],
                    ),
                    child: Row(
                      children: [
                        posterPath != null
                            ? Image.network(
                                ApiClient.imageUrl(posterPath),
                                width: 95,
                              )
                            : const Text('loading...'),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              const SizedBox(height: 20),
                              Text(movie?.title ?? 'null',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600)),
                              const SizedBox(height: 10),
                              Text(
                                  watch.stringFromDate(
                                      relisDate), //!функция в модели для преобразования формата даты
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w800,
                                      color: Colors.black38)),
                              const SizedBox(height: 20),
                              Text(
                                  movie?.overview ??
                                      'null', //!Например в MortalKombate нет описания почемуто///
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis),
                            ],
                          ),
                        ),
                        const SizedBox(width: 5),
                      ],
                    ),
                  ),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                        borderRadius: BorderRadius.circular(10),
                        onTap: () =>
                            watch.onTapMovie(context, movie?.id ?? 507089)

                        //onTapMovie();
                        //! onTapMovie(movie.id);
                        //print(movie.id);
                        // },
                        ),
                  )
                ],
              ),
            );
          },
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
          child: TextField(
            // controller: _serchController,
            onChanged: watch.serchMovies,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              filled: true,

              ///!!!!!!!!!!!!!!!
              fillColor: Colors.white.withAlpha(210),

              labelText: 'Поиск',
            ),
          ),
        )
      ],
    );
  }
}
