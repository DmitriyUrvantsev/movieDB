import 'package:flutter/material.dart';
import 'package:movie_db_hard/ui/widgets/my_screen/movie_details/movie_deteils_model.dart';

import '../../../../domain/api_client/api_client.dart';

class SeriesCastWidget extends StatelessWidget {
  const SeriesCastWidget({super.key});

  @override
  Widget build(BuildContext context) {
    const text = Text(
      'Series Cast',
      style: TextStyle(
          fontSize: 16, fontWeight: FontWeight.w700, color: Colors.black87),
    );
    final acters = MovieDetailsModelProvider.read(context)
        ?.model
        .movieDetails
        ?.credits
        ?.cast;
    String? posterPath;

    return ColoredBox(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(10.0),
            child: text,
          ),
          SizedBox(
            height: 400,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: acters?.length ?? 0,
              itemExtent: 170,
              itemBuilder: (BuildContext context, int index) {
                acters != null
                    ? posterPath = acters[index].profile_path
                    : posterPath = '';

                ///rH3GXMtjB73W8G2toCa6wZZqeAD.jpg'

                //
                //
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
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
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black45,
                              offset: Offset(0, 3),
                              blurRadius: 10,

                              //blurStyle: BlurStyle.normal
                            )
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              //color: Colors.black,
                              height: 200,
                              width: 170,
                              child: posterPath != null
                                  ? Image.network(
                                      ApiClient.imageUrl(posterPath!),
                                      fit: BoxFit.cover,
                                    )
                                  : ColoredBox(
                                      color: Colors.grey.shade400,
                                      child: const Center(
                                          child: Text('Not photo')),
                                    ),
                            ),
                            //const SizedBox(width: 10),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 15),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                        //'kjhk',
                                        acters?[index].name ?? 'Error',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600)),
                                    const SizedBox(height: 10),
                                    Text(acters?[index].character ?? 'Error',
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w800,
                                            color: Colors.black38)),
                                    const SizedBox(height: 20),
                                  ],
                                ),
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
                          onTap: () => {},
                          //watch.onTapMovie(context, movie?.id?? 507089)
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
          ),
          TextButton(
              onPressed: () {},
              child: const Text(
                'Full Cast & Crew',
                style: TextStyle(fontSize: 16),
              ))
        ],
      ),
    );
  }
}
