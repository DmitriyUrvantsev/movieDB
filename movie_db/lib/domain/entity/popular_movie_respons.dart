// ignore_for_file: public_member_api_docs, sort_constructors_first, non_constant_identifier_names
import 'package:json_annotation/json_annotation.dart';

import 'movie.dart';

part 'popular_movie_respons.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
//! snake - пареименовывает P в _; explicitToJson: true - обязательно, т.к. внутри вложенные парсеры(List<Movie> )
class PopularMovieRespons {
  final int page;
  @JsonKey(name: 'results')
  final List<Movies> movies;
  final int total_pages;
  final int total_results;
  PopularMovieRespons({
    required this.page,
    required this.movies,
    required this.total_pages,
    required this.total_results,
  });

  factory PopularMovieRespons.fromJson(Map<String, dynamic> json) =>
      _$PopularMovieResponsFromJson(json);
  Map<String, dynamic> toJson() => _$PopularMovieResponsToJson(this);
}
