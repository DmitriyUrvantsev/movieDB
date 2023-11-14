// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:io';

import '../entity/movie_details.dart';
import '../entity/popular_movie_respons.dart';

/*Ошибки бывают:
--
1) нет сети;//?Network
2) нет ответа сети, таймаут соединения;
----
----
3) сервер не доступен;//?Auth
4) сервер не может обработать запрашиваемый запрос;
5) сервер ответил не то, что мы ожидаем;
----
----
6) сервер ответил ожидаемой ошибкой;//?Other
--
*/
enum ApiClientExeptionType { network, auth, other, sessionExpired }

enum MediaType { movie, tv }

//!не забудь потом обозначить как !!!as!!!String:  ..."media_type": mediaType.asString(),... в запросе
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
  //***** наш класс для стандартизации ошибок на три вида(Сеть? Авторизация? Другие?) */ */
  final ApiClientExeptionType type;
  ApiClientExeption({
    required this.type,
  });
}

class ApiClient {
  final client = HttpClient();

  static const _host = 'https://api.themoviedb.org/3';
  static const _imageUrl =
      'https://image.tmdb.org/t/p/w500'; //! нужно разобраться откуда брать!!!!
  static const _apiKey = '3265ced0659ed12cbd2de72d990a4bc2';

  static String imageUrl(String path) => _imageUrl + path;

  Future<String> auth(
      {required String username, required String password}) async {
    final token = await _makeToken();
    final validToken = await _validateUser(
        username: username, password: password, requestToken: token);
    final sessionId = await _makeSession(requestToken: validToken);
    return sessionId;
    //return validToken;
  }

  Uri _makeUri(String path, [Map<String, dynamic>? parameters]) {
    //хелпер для написания url, типа в одном месте можно поменять Хост
    final uri = Uri.parse('$_host$path');
    if (parameters != null) {
      return uri.replace(queryParameters: parameters);
    } else {
      return uri;
    }
  }

  //!-----------------------------------------------------------------------------
  //!-----------------------------------------------------------------------------

  Future<String> _makeToken() async {
    //!Create Request Token
    //final url = Uri.parse(
    //    'https://api.themoviedb.org/3/authentication/token/new?api_key=$_apiKey');//!отрефачено
    final url = _makeUri('/authentication/token/new',
        <String, dynamic>{'api_key': _apiKey}); //!api_key - параметры

    try {
      final request = await client.getUrl(url);
      //           собираем наш request(запрос) //!await **
      //.          //! здесь может быть ошибка отсутствия сети - *****SocketException
      final respons = await request.close();
      //           close() - выполняем наш request(запрос) и отправляем на сервер//!await
      //.           //!здесь может быть ошибка когда сервер недоступен - *****SocketException
      //----------------------------------------***-----------------------

      final jsonStrings = await respons.transform(utf8.decoder).toList();
      //           получение ответа сервера в виде: //!СТРИМА - байт(цифры): нужно переделать в СТРИМ строк(Json)(transform(utf8.decoder))
      //           можно прослушать этот СТРИМ: respons.transform(utf8.decoder).listen((event) {   });
      //           либо преобразовать в массив List: respons.transform(utf8.decoder).toList();
      //.           ! это будет List Json_строк!!!!!, не String!!! ____ //!await!!

      final jsonString = jsonStrings.join();
      //            склеиваем в одну строку <dynamic>
      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      //             преобразовываем в настоящий файл
      //.            //! здесь может быть ошибка неправильного парсинга
      //---------
      _validateResponse(respons, json); //!ПРОВЕРКА
      //-----
      final token = json['request_token'] as String;
      //.           //! здесь может быть ошибка отсутствия json-токена
      return token;
    }
    //---------------------\\\\\-------
    on SocketException {
      //сети - SocketException
      throw ApiClientExeption(type: ApiClientExeptionType.network);
      //-------Network
    } on ApiClientExeption {
      // наша throw ApiClientExeption(type: ApiClientExeptionType.Auth); попадет сюда
      rethrow; //- проброс ошибки выше
    }
    //-------Auth

    catch (_) {
      //ловим остальные ошибки. (_) - будем игнорировать/ вместо нее. будем throwить свою ошибку: Other
      throw ApiClientExeption(type: ApiClientExeptionType.other);
    }
    //-------Other
  }

  //!-----------------------------------------------------------------------------
  //!-----------------------------------------------------------------------------

  Future<String> _validateUser({
    //!Create Session (with login)
    required String username,
    required String password,
    required String requestToken,
  }) async {
    // final url = Uri.parse(
    //     'https://api.themoviedb.org/3/authentication/token/validate_with_login?api_key=$_apiKey');//!отрефачено
    final url = _makeUri('/authentication/token/validate_with_login',
        <String, dynamic>{'api_key': _apiKey}); //!api_key - параметры

    try {
      final parameters = <String, dynamic>{
        'username': username,
        'password': password,
        'request_token': requestToken
      };
      //параметры которые будут у нашего Body, которые будем передавать на сервер

      final request = await client.postUrl(url);
      //------request.headers.set('Content-type', 'aplication/json; charset=UTF-8');
      request.headers.contentType =
          ContentType.json; // можно и так? чтобы не ошибиться
      //устанавливаем новый header(смотрим в документации сервера) - это ключ-значение (тип ,значение)
      request.write(jsonEncode(parameters));
      //преобразовываем jsonEncode(parameters) parameters(Мапу параметров - обьект)
      // в строку и добисать эту строку в body request.write(
      final respons = await request.close();

      //close() - выполняем наш request(запрос) и отправляем на сервер//!await
      final jsonStrings = await respons.transform(utf8.decoder).toList();
      final jsonString = jsonStrings.join();
      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      _validateResponse(respons, json); //!ПРОВЕРКА

      final token = json['request_token'] as String;
      return token;
    } //---------------------\\\\\-------
    on SocketException {
      //сети - SocketException
      throw ApiClientExeption(type: ApiClientExeptionType.network);
      //-------Network
    } on ApiClientExeption {
      // наша throw ApiClientExeption(type: ApiClientExeptionType.Auth); попадет сюда
      rethrow; //- проброс ошибки выше
    }
    //-------Auth

    catch (_) {
      //ловим остальные ошибки. (_) - будем игнорировать/ вместо нее. будем throwить свою ошибку: Other
      throw ApiClientExeption(type: ApiClientExeptionType.other);
    }
    //-------Other
  }

  //!-----------------------------------------------------------------------------
  //!-----------------------------------------------------------------------------

  Future<String> _makeSession({
    //!Create Session
    required String requestToken,
  }) async {
    final url = _makeUri('/authentication/session/new',
        <String, dynamic>{'api_key': _apiKey}); //!api_key - параметры

    try {
      final parameters = <String, dynamic>{'request_token': requestToken};

      final request = await client.postUrl(url);

      request.headers.contentType = ContentType.json;
      request.write(jsonEncode(parameters));
      final respons = await request.close();

      final jsonStrings = await respons.transform(utf8.decoder).toList();
      final jsonString = jsonStrings.join();
      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      _validateResponse(respons, json); //!ПРОВЕРКА

      final sessionId = json['session_id'] as String;
      return sessionId;
    }
//---------------------\\\\\-------
    on SocketException {
      //сети - SocketException
      throw ApiClientExeption(type: ApiClientExeptionType.network);
      //-------Network
    } on ApiClientExeption {
      // наша throw ApiClientExeption(type: ApiClientExeptionType.Auth); попадет сюда
      rethrow; //- проброс ошибки выше
    }
    //-------Auth

    catch (_) {
      //ловим остальные ошибки. (_) - будем игнорировать/ вместо нее. будем throwить свою ошибку: Other
      throw ApiClientExeption(type: ApiClientExeptionType.other);
    }
    //-------Other
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
  // Future<PopularMovieRespons> getPopularMovies(
  //   //!капец как тяжело))) без хелперов  проще было понять.. Позже нужно будет разобраться и закрепить
  //   String locale,
  //   int page,
  // ) async {
  //   // ignore: prefer_function_declarations_over_variables
  //   final parser = (dynamic json) {
  //     final jsonMap = json as Map<String, dynamic>;
  //     final response = PopularMovieRespons.fromJson(jsonMap);
  //     return response;
  //   };
  //   final result = _get(
  //     '/movie/popular',
  //     parser,
  //     <String, dynamic>{
  //       'api_key': _apiKey,
  //       'page': page.toString(),
  //       'language': locale,
  //     },
  //   );
  //   return result;
  // }
//-----------типа без хелперов но с косяками---------------------------------------------------
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
      _validateResponse(respons, resultFile); //!ПРОВЕРКА

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
      _validateResponse(respons, resultFile); //!ПРОВЕРКА

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
      _validateResponse(respons, resultFile); //!ПРОВЕРКА

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

    //required String requestToken,
  }) async {
    final accountIdInt = int.tryParse(accountId);
    final url = _makeUri('/account/$accountIdInt/favorite', <String, dynamic>{
      'api_key': _apiKey,
      'session_id': sessionId
    }); //!api_key - параметры

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
      _validateResponse(respons, json); //!ПРОВЕРКА

      final result = json['success'] as bool;
      return result;
    }
//---------------------\\\\\-------
    on SocketException {
      //сети - SocketException
      throw ApiClientExeption(type: ApiClientExeptionType.network);
      //-------Network
    } on ApiClientExeption {
      // наша throw ApiClientExeption(type: ApiClientExeptionType.Auth); попадет сюда
      rethrow; //- проброс ошибки выше
    }
    //-------Auth

    catch (_) {
      //ловим остальные ошибки. (_) - будем игнорировать/ вместо нее. будем throwить свою ошибку: Other
      throw ApiClientExeption(type: ApiClientExeptionType.other);
    }
    //-------Other
  }

//!-----------------------------------------------------------------------------
//!-----------------------------------------------------------------------------

//!--------- хелперы хелперы хелперы хелперы хелперы ----- + ПЛЮС хелперы см. видос 64
  void _validateResponse(
      //хелпер проверки правильности паролей и авторизации
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
      } //ловим ошибки авторизации : и генерируем свою ошибку throw попадет в низ
    }
  }

//!--------

  // Future<T> _get<T>(
  //   String path,
  //   T Function(dynamic json) parser, [
  //   Map<String, dynamic>? parametrs,
  // ]) async {
  //   final url = _makeUri(path, parametrs);
  //   try {
  //     final request = await client.getUrl(url);
  //     final dynamic response = await request.close();
  //     final json = (await response.jsonDecode());
  //     _validateResponse(response, json);
  //     final result = parser(json);
  //     return result;
  //   } on SocketException {
  //     throw ApiClientExeption(type: ApiClientExeptionType.network);
  //   } on ApiClientExeption {
  //     rethrow;
  //   } catch (_) {
  //     throw ApiClientExeption(type: ApiClientExeptionType.other);
  //   }
  // }

  //!--------

//   Future<T> _posr<T>(
//     String path,
//     Map<String, dynamic> bodyParametrs,
//     T Function(dynamic json) parser, [
//     Map<String, dynamic>? urlParametrs,
//   ]) async {
//     try {
//       final url = _makeUri(path, urlParametrs);
//       final request = await client.postUrl(url);

//       request.headers.contentType = ContentType.json;
//       request.write(jsonEncode(bodyParametrs));
//       final dynamic response = await request.close();
//       final json = (await response.jsonDecode());
//       _validateResponse(response, json);

//       final result = parser(json);
//       return result;
//     } on SocketException {
//       throw ApiClientExeption(type: ApiClientExeptionType.network);
//     } on ApiClientExeption {
//       rethrow;
//     } catch (_) {
//       throw ApiClientExeption(type: ApiClientExeptionType.other);
//     }
//   }
// }

// extension HttpClientResponseJsonDecode on HttpClientResponse {
//   Future<dynamic> jsonDecode() async {
//     return transform(utf8.decoder).toList().then((value) {
//       final result = value.join();
//       return result;
//     }).then((v) => json.decode(v));
//   }
}
