// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class MovieDetailsTrailerWidget extends StatefulWidget {
  String youTubeKey;
  MovieDetailsTrailerWidget({
    Key? key,
    required this.youTubeKey,
  }) : super(key: key);

  @override
  State<MovieDetailsTrailerWidget> createState() =>
      _MovieDetailsTrailerWidgetState();
}

class _MovieDetailsTrailerWidgetState extends State<MovieDetailsTrailerWidget> {
  late YoutubePlayerController _controller;
  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
        initialVideoId: widget.youTubeKey,
        flags: const YoutubePlayerFlags(
          mute: false,
          autoPlay: true,
          disableDragSeek: false,
          loop: false,
          isLive: false,
          forceHD: false,
          enableCaption: true,
        ));
  }

  @override
  Widget build(BuildContext context) {
    YoutubePlayer youtubePlayer = YoutubePlayer(
      controller: _controller,
      showVideoProgressIndicator: true,
      progressIndicatorColor: Colors.blueAccent,
      topActions: <Widget>[
        const SizedBox(width: 8.0),
        const Expanded(
          child: Text(
            'title',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.0,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
        IconButton(
          icon: const Icon(
            Icons.settings,
            color: Colors.white,
            size: 25.0,
          ),
          onPressed: () {
            //log('Settings Tapped!');
          },
        ),
      ],
    );

    return YoutubePlayerBuilder(
        player: youtubePlayer,
        builder: (context, player) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Trailer'),
            ),
            body: youtubePlayer,
          );
        });
  }
}
