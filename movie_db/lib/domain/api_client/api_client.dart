import 'dart:convert';
import 'dart:io';
import '../entity/movie_details.dart';
import '../entity/popular_movie_respons.dart';

enum ApiClientExeptionType { network, auth, other, sessionExpired }

enum MediaType { movie, tv }

extension MediaTypeAsString on MediaType {
  String asString() {
    switch (this) {
      case MediaType.movie:
        return 'movie';
      case MediaType.tv:
        return 'tv';
    }
  }
}

class ApiClientExeption implements Exception {
  final ApiClientExeptionType type;
  ApiClientExeption({
    required this.type,
  });
}

class ApiClient {
  final client = HttpClient();

  static const _host = 'https://api.themoviedb.org/3';
  static const _imageUrl = 'https://image.tmdb.org/t/p/w500';
  static const _apiKey = '3265ced0659ed12cbd2de72d990a4bc2';

  static String imageUrl(String path) => _imageUrl + path;

  Future<String> auth(
      {required String username, required String password}) async {
    final token = await _makeToken();
    final validToken = await _validateUser(
        username: username, password: password, requestToken: token);
    final sessionId = await _makeSession(requestToken: validToken);
    return sessionId;
  }

  Uri _makeUri(String path, [Map<String, dynamic>? parameters]) {
    final uri = Uri.parse('$_host$path');
    if (parameters != null) {
      return uri.replace(queryParameters: parameters);
    } else {
      return uri;
    }
  }

  //!-----------------------------------------------------------------------------

  Future<String> _makeToken() async {
    final url = _makeUri(
        '/authentication/token/new', <String, dynamic>{'api_key': _apiKey});

    try {
      final request = await client.getUrl(url);
      final respons = await request.close();
      final jsonStrings = await respons.transform(utf8.decoder).toList();
      final jsonString = jsonStrings.join();
      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      _validateResponse(respons, json);
      final token = json['request_token'] as String;
      return token;
    }
    //---------------------\\\\\-------
    on SocketException {
      throw ApiClientExeption(type: ApiClientExeptionType.network);
    } on ApiClientExeption {
      rethrow; //- проброс ошибки выше
    } catch (_) {
      throw ApiClientExeption(type: ApiClientExeptionType.other);
    }
  }

  //!-----------------------------------------------------------------------------
  //!-----------------------------------------------------------------------------

  Future<String> _validateUser({
    required String username,
    required String password,
    required String requestToken,
  }) async {
    final url = _makeUri('/authentication/token/validate_with_login',
        <String, dynamic>{'api_key': _apiKey});

    try {
      final parameters = <String, dynamic>{
        'username': username,
        'password': password,
        'request_token': requestToken
      };
      final request = await client.postUrl(url);
      request.headers.contentType = ContentType.json;
      request.write(jsonEncode(parameters));
      final respons = await request.close();
      final jsonStrings = await respons.transform(utf8.decoder).toList();
      final jsonString = jsonStrings.join();
      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      _validateResponse(respons, json);

      final token = json['request_token'] as String;
      return token;
    } //---------------------\\\\\-------
    on SocketException {
      throw ApiClientExeption(type: ApiClientExeptionType.network);
    } on ApiClientExeption {
      rethrow;
    } catch (_) {
      //ловим остальные ошибки. (_) - будем игнорировать/ вместо нее. будем throwить свою ошибку: Other
      throw ApiClientExeption(type: ApiClientExeptionType.other);
    }
  }

  //!-----------------------------------------------------------------------------
  //!-----------------------------------------------------------------------------

  Future<String> _makeSession({
    //!Create Session
    required String requestToken,
  }) async {
    final url = _makeUri(
        '/authentication/session/new', <String, dynamic>{'api_key': _apiKey});

    try {
      final parameters = <String, dynamic>{'request_token': requestToken};

      final request = await client.postUrl(url);

      request.headers.contentType = ContentType.json;
      request.write(jsonEncode(parameters));
      final respons = await request.close();

      final jsonStrings = await respons.transform(utf8.decoder).toList();
      final jsonString = jsonStrings.join();
      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      _validateResponse(respons, json);

      final sessionId = json['session_id'] as String;
      return sessionId;
    }
//---------------------\\\\\-------
    on SocketException {
      throw ApiClientExeption(type: ApiClientExeptionType.network);
    } on ApiClientExeption {
      rethrow;
    } catch (_) {
      throw ApiClientExeption(type: ApiClientExeptionType.other);
    }
  }

//!-----------------------------------------------------------------------------
//!-----------------------------------------------------------------------------
  Future<int> getAccountID({required String sessionId}) async {
    final parameters = <String, dynamic>{
      'api_key': _apiKey,
      'session_id': sessionId,
    };
    final url = _makeUri('/account', parameters);

    try {
      final request = await client.getUrl(url);
      final respons = await request.close();

      final jsonMaps = await respons.transform(utf8.decoder).toList();
      final jsonMap = jsonMaps.join();
      final resultFile = jsonDecode(jsonMap) as Map<String, dynamic>;
      _validateResponse(respons, resultFile); //!ПРОВЕРКА

      final result = resultFile['id'] as int;
      return result;
    } //---------------------\\\\\-------
    on SocketException {
      throw ApiClientExeption(type: ApiClientExeptionType.network);
    } on ApiClientExeption {
      rethrow;
    } catch (_) {
      throw ApiClientExeption(type: ApiClientExeptionType.other);
    }
  }

//!-----------------------------------------------------------------------------
//!-----------------------------------------------------------------------------
  Future<PopularMovieRespons> getPopularMovies(
    String locale,
    int page,
  ) async {
    final parameters = <String, dynamic>{
      'api_key': _apiKey,
      'language': locale,
      'page': page.toString(),
    };
    final url = _makeUri('/movie/popular', parameters);

    try {
      final request = await client.getUrl(url);
      final respons = await request.close();

      final jsonMaps = await respons.transform(utf8.decoder).toList();
      final jsonMap = jsonMaps.join();
      final resultFile = jsonDecode(jsonMap) as Map<String, dynamic>;
      _validateResponse(respons, resultFile);

      final result = PopularMovieRespons.fromJson(resultFile);
      return result;
    } //---------------------\\\\\-------
    on SocketException {
      throw ApiClientExeption(type: ApiClientExeptionType.network);
    } on ApiClientExeption {
      rethrow;
    } catch (_) {
      throw ApiClientExeption(type: ApiClientExeptionType.other);
    }
  }

  //!-----------------------------------------------------------------------------

  Future<PopularMovieRespons> getSerchMovies({
    required String query,
    required String locale,
    required int page,
  }) async {
    final parameters = <String, dynamic>{
      'api_key': _apiKey,
      'language': locale,
      'page': page.toString(),
      'query': query,
    };
    final url = _makeUri('/search/movie', parameters);

    try {
      final request = await client.getUrl(url);
      final respons = await request.close();

      final jsonMaps = await respons.transform(utf8.decoder).toList();
      final jsonMap = jsonMaps.join();
      final resultFile = jsonDecode(jsonMap) as Map<String, dynamic>;
      _validateResponse(respons, resultFile);

      final result = PopularMovieRespons.fromJson(resultFile);
      return result;
    } //---------------------\\\\\-------
    on SocketException {
      throw ApiClientExeption(type: ApiClientExeptionType.network);
    } on ApiClientExeption {
      rethrow;
    } catch (_) {
      throw ApiClientExeption(type: ApiClientExeptionType.other);
    }
  }

  //!-----------------------------------------------------------------------------

  Future<MovieDetails> getMovieDetails(
      {required String locale, required int movieId}) async {
    final parameters = <String, dynamic>{
      'api_key': _apiKey,
      'language': locale,
      'append_to_response': 'videos,credits'
    };
    final url = _makeUri('/movie/$movieId', parameters);

    try {
      final request = await client.getUrl(url);
      final respons = await request.close();

      final jsonMaps = await respons.transform(utf8.decoder).toList();
      final jsonMap = jsonMaps.join();
      final resultFile = jsonDecode(jsonMap) as Map<String, dynamic>;
      _validateResponse(respons, resultFile); //!ПРОВЕРКА

      final result = MovieDetails.fromJson(resultFile);
      return result;
    } //---------------------\\\\\-------
    on SocketException {
      throw ApiClientExeption(type: ApiClientExeptionType.network);
    } on ApiClientExeption {
      rethrow;
    } catch (_) {
      throw ApiClientExeption(type: ApiClientExeptionType.other);
    }
  }

  //!-----------------------------------------------------------------------------

  Future<bool> getChekIsFavorite(
      {required String sessionId, required int movieId}) async {
    final parameters = <String, dynamic>{
      'api_key': _apiKey,
      'session_id': sessionId,
    };
    final url = _makeUri('/movie/$movieId/account_states', parameters);

    try {
      final request = await client.getUrl(url);
      final respons = await request.close();

      final jsonMaps = await respons.transform(utf8.decoder).toList();
      final jsonMap = jsonMaps.join();
      final resultFile = jsonDecode(jsonMap) as Map<String, dynamic>;
      _validateResponse(respons, resultFile);

      final result = resultFile['favorite'] as bool;
      return result;
    } //---------------------\\\\\-------
    on SocketException {
      throw ApiClientExeption(type: ApiClientExeptionType.network);
    } on ApiClientExeption {
      rethrow;
    } catch (_) {
      throw ApiClientExeption(type: ApiClientExeptionType.other);
    }
  }

//!-----------------------------------------------------------------------------
  Future<bool> toglleFavorite({
    required String accountId,
    required String sessionId,
    required int movieId,
    required bool isFavorite,
    required MediaType mediaType,
  }) async {
    final accountIdInt = int.tryParse(accountId);
    final url = _makeUri('/account/$accountIdInt/favorite',
        <String, dynamic>{'api_key': _apiKey, 'session_id': sessionId});

    try {
      final parameters = <String, dynamic>{
        "media_type": mediaType.asString(),
        "media_id": movieId,
        "favorite": isFavorite
      };

      final request = await client.postUrl(url);

      request.headers.contentType = ContentType.json;
      request.write(jsonEncode(parameters));
      final respons = await request.close();

      final jsonStrings = await respons.transform(utf8.decoder).toList();
      final jsonString = jsonStrings.join();
      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      _validateResponse(respons, json);

      final result = json['success'] as bool;
      return result;
    }
//---------------------\\\\\-------
    on SocketException {
      throw ApiClientExeption(type: ApiClientExeptionType.network);
    } on ApiClientExeption {
      rethrow;
    } catch (_) {
      throw ApiClientExeption(type: ApiClientExeptionType.other);
    }
  }

//!-----------------------------------------------------------------------------

  void _validateResponse(
      //хелпер проверки
      HttpClientResponse respons,
      Map<String, dynamic> json) {
    if (respons.statusCode == 401) {
      final dynamic status = json['status_code'];
      final code = status is int ? status : 0;
      if (code == 30) {
        //?когда не верный логин пароль
        throw ApiClientExeption(type: ApiClientExeptionType.auth);
      } else if (code == 3) {
        //? когда не верный sessionId
        throw ApiClientExeption(type: ApiClientExeptionType.sessionExpired);
      } else {
        throw ApiClientExeption(type: ApiClientExeptionType.other);
      }
    }
  }
}
