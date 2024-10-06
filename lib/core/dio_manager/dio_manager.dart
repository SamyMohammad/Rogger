import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class DioHelper {
  // static const _environment = String.fromEnvironment('env', defaultValue: "dev");
  // static final String _environmentBaseUrl = _environment == 'dev' ? 'https://web2html5.com/m/sila2' : 'http://www.sila2.com';
  // static final String _baseUrl = "$_environmentBaseUrl/index.php?route=api/collection/";
  // static final String _baseUrl =
  //     "http://www.sila2.com/index.php?route=api/collection/";
  static final String _baseUrl =
      "https://roogr.sa/api/index.php?route=api/collection/";
  //new base url "https://roogr.sa/api/index.php?route=api/collection/";

  // static final String _baseUrl = "http://www.sila2.com/index.php?route=api/collection/";
  static final String _apiKey =
      "iBd6vXV2fK3TkojQQdGMsQ4csGnUqcPux7aOy8TqdSQc8dTj2ODSEAi4fvDosUVQMFxTnydlCJZ5zqZY3Vm4RVGV2eGXRjcHo5cpAIYXNQOWES7Yhccg1w8SSwJOt5QwEUrho0HuftoNdifoHroYkFU1kbiZcpEk6OaxzhAeUi7H8aASjTnXSUFJnBSL242grzbDD4S6L84hypCH3LKek16U5yg4ZUSqwUPjQlJ3qhM5IWTXevthpl4fycNjeo2b";

  static late Dio _dio;

  static void init() {
    if (kDebugMode) HttpOverrides.global = _MyHttpOverrides();
    _dio = Dio()..options.baseUrl = _baseUrl;
    _dio.interceptors.add(PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseBody: true,
      responseHeader: false,
      error: true,
      compact: true,
      maxWidth: 90,
      enabled: kDebugMode,
    ));
  }

  static Future<Response<dynamic>> get(String path) async {
    // _dio.options.headers = {
    //   // if(AppStorage.isLogged)
    //   //   'Authorization': AppStorage.userInfo.token
    // };
    return await _dio.get(path);
  }

  static Future<Response<dynamic>> post(String path,
      {Map<String, dynamic>? data,
      FormData? formData,
      Map<String, dynamic>? params}) async {
    // _dio.options.headers = {
    //   'lang': 'en',
    //   // if(AppStorage.isLogged)
    //   //   'Authorization': AppStorage.userInfo.token
    // };
    if (data == null) {
      data = {};
    }
    if (formData != null) {
      formData.fields.add(MapEntry(
        'key',
        _apiKey,
      ));
    }
    data.addAll({'key': _apiKey});
    return await _dio.post(path,
        data: formData ?? FormData.fromMap(data), queryParameters: params);
  }

  static Future<Response<dynamic>> put(String path, {var data}) async {
    _dio.options.headers = {
      'lang': 'en',
      // if(AppStorage.isLogged)
      //   'Authorization': AppStorage.userInfo.token
    };
    return await _dio.put(path, data: data);
  }

  static Future<Response<dynamic>> delete(String path, {var data}) async {
    _dio.options.headers = {
      'lang': 'en',
      // if(AppStorage.isLogged)
      //   'Authorization': AppStorage.userInfo.token
    };
    return await _dio.delete(path, data: data);
  }
}

class _MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
