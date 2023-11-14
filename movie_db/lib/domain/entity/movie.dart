// ignore_for_file: public_member_api_docs, sort_constructors_first, non_constant_identifier_names
import 'package:json_annotation/json_annotation.dart';

import 'movie_date_parser.dart';

part 'movie.g.dart';

@JsonSerializable(
    fieldRename: FieldRename.snake) //переименует backdrop_path в backdropPath
class Movies {
  final bool? adult;
  final String? backdrop_path;
  final List<int>? genre_ids;
  final int? id;
  final String? original_language;
  final String? original_title;
  final String? overview;
  final double? popularity;
  final String? poster_path;
  //!-----------парсинг даты которая изначально идет как String, см функцию ниже
  @JsonKey(fromJson: parseMovieDateFromString)
  final DateTime?
      release_date; //!в документации стоит String!!!, типа чтобы парсилось d дату
  //!------

  final String? title;
  final bool? video;
  final double? vote_average;
  final int? vote_count;
  Movies({
    this.adult,
    this.backdrop_path,
    this.genre_ids,
    this.id,
    this.original_language,
    this.original_title,
    this.overview,
    this.popularity,
    this.poster_path,
    required this.release_date,
    this.title,
    this.video,
    this.vote_average,
    this.vote_count,
  });

  factory Movies.fromJson(Map<String, dynamic> json) => _$MoviesFromJson(json);
  Map<String, dynamic> toJson() => _$MoviesToJson(this);
}
