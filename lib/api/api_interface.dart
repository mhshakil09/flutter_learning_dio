import 'dart:async';
import 'dart:async';
import 'dart:core';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_learning_dio/services/dio_services.dart';

class ApiCallObject extends DioClient {
  // Dio dioClient = DioClient().dio;

  Future<Response> getData(String endPoint) async {
    Response response;

    print("step 12");
    try {
      response = await dio.get(endPoint);
      print("step 13");
      if (response.statusCode == 200) {
        return response;
      } else {
        print("There is some problem status code not 200");
        throw response.statusMessage.toString();
      }
    } on DioError catch (error) {
      throw Exception(error.message);
    }
  }

  Future<Response> getTestList(String endPoint) async {
    Response response;

    print("step 12");
    try {
      response = await dio.get(endPoint);
      print("step 13");
      if (response.statusCode == 200) {
        return response;
      } else {
        print("There is some problem status code: $response.statusCode");
        throw response.statusMessage.toString();
      }
    } on DioError catch (error) {
      throw Exception(error.message);
    }
  }
}
