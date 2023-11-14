// ignore_for_file: public_member_api_docs, sort_constructors_first, non_constant_identifier_names
import 'package:json_annotation/json_annotation.dart';

import 'movie_date_parser.dart';

part 'movie_details.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class MovieDetails {
  final bool? adult;
  final String? backdrop_path;
  final BelongsToCollection? belongs_to_collection;
  final int? budget;
  final List<Genre>? genres;
  final String? homepage;
  final int? id;
  final String? imdb_id;
  final String? original_language;
  final String? original_title;
  final String? overview;
  final double? popularity;
  final String? poster_path;
  final List<ProductionCompanie>? production_companies;
  final List<ProductionCountrie>? production_countries;

  final Videos? videos;
  final Credits? credits;

  //!-----------парсинг даты которая изначально идет как String, см функцию ниже
  @JsonKey(fromJson: parseMovieDateFromString)
  final DateTime?
      release_date; //!в документации стоит String!!!, типа чтобы парсилось d дату
  //!------

  final int? revenue;
  final int? runtime;
  final List<SpokenLanguage>? spoken_languages;
  final String? status;
  final String? tagline;
  final String title;
  final bool? video;
  final double? vote_average;
  final int? vote_count;
  MovieDetails({
    this.adult,
    this.backdrop_path,
    this.belongs_to_collection,
    this.budget,
    this.genres,
    this.homepage,
    this.id,
    this.imdb_id,
    this.original_language,
    this.original_title,
    this.overview,
    this.popularity,
    this.poster_path,
    this.production_companies,
    this.production_countries,
    this.videos,
    this.credits,
    required this.release_date,
    this.revenue,
    this.runtime,
    this.spoken_languages,
    this.status,
    this.tagline,
    required this.title,
    this.video,
    this.vote_average,
    this.vote_count,
  });

  factory MovieDetails.fromJson(Map<String, dynamic> json) =>
      _$MovieDetailsFromJson(json);
  Map<String, dynamic> toJson() => _$MovieDetailsToJson(this);

//  static DateTime? _parseDateFromString(String? rewDate) {//! сделаем метод в одном файле Movie , будет общим
//     //!обязательно static
//     if (rewDate == null || rewDate.isEmpty) return null;
//     return DateTime.tryParse(rewDate);
//  }
}

@JsonSerializable(fieldRename: FieldRename.snake)
class BelongsToCollection {
  BelongsToCollection();

  factory BelongsToCollection.fromJson(Map<String, dynamic> json) =>
      _$BelongsToCollectionFromJson(json);
  Map<String, dynamic> toJson() => _$BelongsToCollectionToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class Genre {
  final int? id;
  final String? name;
  Genre(
    this.id,
    this.name,
  );
  factory Genre.fromJson(Map<String, dynamic> json) => _$GenreFromJson(json);
  Map<String, dynamic> toJson() => _$GenreToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class ProductionCompanie {
  final int? id;
  final String? logo_path;
  final String? name;
  final String? origin_country;
  ProductionCompanie(
    this.id,
    this.logo_path,
    this.name,
    this.origin_country,
  );
  factory ProductionCompanie.fromJson(Map<String, dynamic> json) =>
      _$ProductionCompanieFromJson(json);
  Map<String, dynamic> toJson() => _$ProductionCompanieToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class ProductionCountrie {
  @JsonKey(name: 'iso_3166_1')
  final String? isoProduction;
  final String? name;
  ProductionCountrie(
    this.isoProduction,
    this.name,
  );
  factory ProductionCountrie.fromJson(Map<String, dynamic> json) =>
      _$ProductionCountrieFromJson(json);
  Map<String, dynamic> toJson() => _$ProductionCountrieToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class SpokenLanguage {
  @JsonKey(name: 'iso_639_1')
  final String? english_name;
  final String? isoLanguage;
  final String? name;
  SpokenLanguage({
    this.english_name,
    this.isoLanguage,
    this.name,
  });

  factory SpokenLanguage.fromJson(Map<String, dynamic> json) =>
      _$SpokenLanguageFromJson(json);
  Map<String, dynamic> toJson() => _$SpokenLanguageToJson(this);
}

//!----------------------------------
@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class Videos {
  final List<Result?>? results;
  Videos({
    required this.results,
  });
  factory Videos.fromJson(Map<String, dynamic> json) => _$VideosFromJson(json);
  Map<String, dynamic> toJson() => _$VideosToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class Result {
  @JsonKey(name: 'iso_639_1')
  final String? isoLanguage;
  @JsonKey(name: 'iso_3166_1')
  final String? isoProduction;
  final String? name;
  final String? key;
  final String? site;
  final int? size;
  final String? type;
  final bool? official;
  final String? published_at;
  final String? id;
  Result({
    this.isoLanguage,
    this.isoProduction,
    this.name,
    this.key,
    this.site,
    this.size,
    this.type,
    this.official,
    this.published_at,
    this.id,
  });
  factory Result.fromJson(Map<String, dynamic> json) => _$ResultFromJson(json);
  Map<String, dynamic> toJson() => _$ResultToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class Credits {
  final List<Cast>? cast;
  final List<Crew>? crew;
  Credits({
    required this.cast,
    required this.crew,
  });
  factory Credits.fromJson(Map<String, dynamic> json) =>
      _$CreditsFromJson(json);
  Map<String, dynamic> toJson() => _$CreditsToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class Cast {
  final bool? adult;
  final int? gender;
  final int? id;
  final String? known_for_department;
  final String? name;
  final String? original_name;
  final double? popularity;
  final String? profile_path;
  final int? cast_id;
  final String? character;
  final String? credit_id;
  final int? order;
  Cast({
    required this.adult,
    required this.gender,
    required this.id,
    required this.known_for_department,
    required this.name,
    required this.original_name,
    required this.popularity,
    required this.profile_path,
    required this.cast_id,
    required this.character,
    required this.credit_id,
    required this.order,
  });
  factory Cast.fromJson(Map<String, dynamic> json) => _$CastFromJson(json);
  Map<String, dynamic> toJson() => _$CastToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class Crew {
  final bool? adult;
  final int? gender;
  final int? id;
  final String? known_for_department;
  final String? name;
  final String? original_name;
  final double? popularity;
  final String? profile_path;
  final String? credit_id;
  final String? department;
  final String? job;
  Crew({
    required this.adult,
    required this.gender,
    required this.id,
    required this.known_for_department,
    required this.name,
    required this.original_name,
    required this.popularity,
    required this.profile_path,
    required this.credit_id,
    required this.department,
    required this.job,
  });
  factory Crew.fromJson(Map<String, dynamic> json) => _$CrewFromJson(json);
  Map<String, dynamic> toJson() => _$CrewToJson(this);
}
