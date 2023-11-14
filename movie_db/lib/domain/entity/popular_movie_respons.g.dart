// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'popular_movie_respons.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PopularMovieRespons _$PopularMovieResponsFromJson(Map<String, dynamic> json) =>
    PopularMovieRespons(
      page: json['page'] as int,
      movies: (json['results'] as List<dynamic>)
          .map((e) => Movies.fromJson(e as Map<String, dynamic>))
          .toList(),
      total_pages: json['total_pages'] as int,
      total_results: json['total_results'] as int,
    );

Map<String, dynamic> _$PopularMovieResponsToJson(
        PopularMovieRespons instance) =>
    <String, dynamic>{
      'page': instance.page,
      'results': instance.movies.map((e) => e.toJson()).toList(),
      'total_pages': instance.total_pages,
      'total_results': instance.total_results,
    };
