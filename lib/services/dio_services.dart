import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_learning_dio/api/api_interface.dart';

class DioClient {
  late Dio dio;
  // final _baseUrl = "https://reqres.in/api";
  final _baseUrl = "https://9083f744-3abf-4bb1-b327-1f9a2b16b5b8.mock.pstmn.io";

  DioClient() {
    print("Dio client constructing");
    dio = Dio(BaseOptions(
      baseUrl: _baseUrl,
      headers: {"Accept": "application/json"},
      responseType: ResponseType.json,
      receiveTimeout: 30000,
      connectTimeout: 30000,
      followRedirects: false,
      receiveDataWhenStatusError: true,
    ));

    // initializeInterceptors();
  }

  initializeInterceptors() {
    dio.interceptors.add(
      InterceptorsWrapper(
        onError: (error, _errorHandler) {
          print(error.message);
        },
        onRequest: (request, _requestHandler) {
          print("${request.method} ${request.path}");
        },
        onResponse: (response, _responseHandler) {
          print(response.data);
        },
      ),
    );
  }
}
