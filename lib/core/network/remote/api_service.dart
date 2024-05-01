import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:logger/logger.dart';
import '../app_constants.dart';

Logger logger = Logger();

enum _MethodType {
  post,
  get,
  put,
  patch,
  delete,
}

class ApiService {
  static const _connectTimeout = Duration(seconds: 30);
  static const _receiveTimeout = Duration(seconds: 30);
  static const _sendTimeout = Duration(seconds: 30);

  Map<String, String> get _defaultHeaders {
    return {
      "Content-Type": Headers.jsonContentType,
    };
  }

  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: AppConstants.baseUrl,
      connectTimeout: _connectTimeout,
      receiveTimeout: _receiveTimeout,
      sendTimeout: _sendTimeout,
    ),
  );

  static init() {
    (_dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient =
        () => HttpClient()..badCertificateCallback = (x, y, z) => true;
  }

  // POST method
  Future<T> post<T>({
    dynamic requestBody,
    Map<String, dynamic>? header,
    bool returnDataOnly = true,
    CancelToken? cancelToken,
    bool ignoreError = false,
    bool logging = true,
    bool waitError = false,
    Duration? sendTimeOut = _sendTimeout,
    Duration? receiveTimeout = _receiveTimeout,
    // bool automaticManageIndicator = true,
    required String url,
    Map<String, dynamic> additionalHeaders = const {},
  }) async {
    return _hitApi(
      cancelToken: cancelToken,
      waitError: waitError,
      url: url,
      header: header,
      returnDataOnly: returnDataOnly,
      // automaticManageIndicator: automaticManageIndicator,
      methodType: _MethodType.post,
      requestBody: requestBody,
      logging: logging,
      additionalHeaders: additionalHeaders,

      receiveTimeout: receiveTimeout,
      ignoreError: ignoreError,

      sendTimeOut: sendTimeOut,
    );
  }

  Future<T> patch<T>({
    dynamic requestBody,
    Map<String, dynamic>? header,
    bool ignoreError = false,
    bool returnDataOnly = true,
    bool logging = true,
    bool waitError = false,
    CancelToken? cancelToken,
    Duration? sendTimeOut = _sendTimeout,
    Duration? receiveTimeout = _receiveTimeout,
    // bool automaticManageIndicator = true,
    required String url,
    Map<String, dynamic> additionalHeaders = const {},
  }) async {
    return _hitApi(
      cancelToken: cancelToken,
      waitError: waitError,
      url: url,
      header: header,
      returnDataOnly: returnDataOnly,
      // automaticManageIndicator: automaticManageIndicator,
      methodType: _MethodType.patch,
      requestBody: requestBody,
      additionalHeaders: additionalHeaders,
      logging: logging,

      receiveTimeout: receiveTimeout,
      sendTimeOut: sendTimeOut,
    );
  }

  // PUT method
  Future<T> put<T>({
    dynamic requestBody,
    Map<String, dynamic>? header,
    bool returnDataOnly = true,
    bool logging = true,
    bool waitError = false,
    CancelToken? cancelToken,
    Duration? sendTimeOut = _sendTimeout,
    Duration? receiveTimeout = _receiveTimeout,
    bool automaticManageIndicator = true,
    required String url,
    Map<String, dynamic> additionalHeaders = const {},
  }) async {
    return _hitApi(
      cancelToken: cancelToken,
      waitError: waitError,
      url: url,
      header: header,
      returnDataOnly: returnDataOnly,
      // automaticManageIndicator: automaticManageIndicator,
      methodType: _MethodType.put,
      requestBody: requestBody,
      additionalHeaders: additionalHeaders,
      logging: logging,

      receiveTimeout: receiveTimeout,
      sendTimeOut: sendTimeOut,
    );
  }

  Future<Response> getData({
    required String url,
    Map<String, dynamic>? data,
  }) async {
    _dio.options.headers = {
      'Content-Type': 'application/json',
    };
    return await _dio.get(url, data: data);
  }

  Future<T> get<T>({
    required String url,
    bool returnDataOnly = true,
    bool automaticManageIndicator = true,
    dynamic requestBody,
    Duration? sendTimeOut = _sendTimeout,
    CancelToken? cancelToken,
    bool logging = true,
    bool waitError = false,
    Duration? receiveTimeout = _receiveTimeout,
    bool ignoreError = false,
    Map<String, dynamic> additionalHeaders = const {},
  }) async {
    return _hitApi(
      cancelToken: cancelToken,
      waitError: waitError,
      url: url,
      returnDataOnly: returnDataOnly,
      methodType: _MethodType.get,
      requestBody: requestBody,
      // automaticManageIndicator: automaticManageIndicator,
      additionalHeaders: additionalHeaders,
      logging: logging,
      receiveTimeout: receiveTimeout,
      sendTimeOut: sendTimeOut,
    );
  }

  Future<Response> delData({
    required String url,
    Map<String, dynamic>? data,
  }) async {
    _dio.options.headers = {
      'Content-Type': 'application/json',
      "api_token": AppConstants.token,
    };
    return await _dio.delete(url, data: data);
  }

  Future<Either<T, Failure>> delete<T>({
    required String url,
    bool returnDataOnly = true,
    bool automaticManageIndicator = true,
    bool logging = true,
    bool waitError = false,
    CancelToken? cancelToken,
    dynamic queryParameters,
    Duration? sendTimeOut = _sendTimeout,
    bool ignoreError = false,
    Duration? receiveTimeout = _receiveTimeout,
    Map<String, dynamic> additionalHeaders = const {},
  }) async {
    return _hitApi(
      cancelToken: cancelToken,
      waitError: waitError,
      url: url,
      returnDataOnly: returnDataOnly,
      methodType: _MethodType.delete,
      requestBody: queryParameters,
      // automaticManageIndicator: automaticManageIndicator,
      additionalHeaders: additionalHeaders,
      logging: logging,

      receiveTimeout: receiveTimeout,
      sendTimeOut: sendTimeOut,
    );
  }

  Future<T> _hitApi<T>({
    required _MethodType methodType,
    required String url,
    bool returnDataOnly = true,
    CancelToken? cancelToken,
    dynamic requestBody,
    bool logging = true,
    bool waitError = false,
    bool ignoreError = false,
    Map<String, dynamic>? header,
    Duration? sendTimeOut = _sendTimeout,
    Duration? receiveTimeout = _receiveTimeout,
    // bool automaticManageIndicator = true,
    Map<String, dynamic> additionalHeaders = const {},
  }) async {
    final Map<String, dynamic> headers =
        header ?? {..._defaultHeaders, ...additionalHeaders};

    if (logging) {
      logger.f(
        "$methodType:${_dio.options.baseUrl + url}\n$headers\n${requestBody ?? ''}",
      );
      if (requestBody is FormData) {
        logger.f((requestBody).fields);
        logger.f((requestBody).files);
      }
    }

    Response<dynamic> response;
    switch (methodType) {
      case _MethodType.post:
        response = await _dio.post(
          url,
          options: Options(
            headers: headers,
            receiveTimeout: receiveTimeout,
            sendTimeout: sendTimeOut,
          ),
          data: requestBody,
          cancelToken: cancelToken,
        );
        break;
      case _MethodType.get:
        response = await _dio.get(
          url,
          options: Options(
            headers: headers,
          ),
          queryParameters: requestBody,
          cancelToken: cancelToken,
        );
        break;
      case _MethodType.put:
        response = await _dio.put(
          url,
          options: Options(
            headers: headers,
            receiveTimeout: receiveTimeout,
            sendTimeout: sendTimeOut,
          ),
          data: requestBody,
          cancelToken: cancelToken,
        );
        break;
      case _MethodType.patch:
        response = await _dio.patch(
          url,
          options: Options(
            headers: headers,
            receiveTimeout: receiveTimeout,
            sendTimeout: sendTimeOut,
          ),
          data: requestBody,
          cancelToken: cancelToken,
        );
        break;
      case _MethodType.delete:
        response = await _dio.delete(
          url,
          options: Options(
            headers: headers,
          ),
          data: requestBody,
          cancelToken: cancelToken,
        );
        break;
    }
    logger.w(response.data);

    if (response.statusCode! >= 200 && response.statusCode! < 300) {
      logger.w(response.data);

      if (returnDataOnly) {
        return (response.data['data'] as T);
      } else {
        return (response.data as T);
      }
    } else {
      throw DioException(requestOptions: response.requestOptions);
    }
  }
}

class APIError extends Failure {
  dynamic status = '';
  bool msgFromServer;

  APIError(
      {this.status,
      dynamic message,
      this.msgFromServer = false,
      required bool ignoreError})
      : super(message ?? '') {
    logger.e("code is $status , and the message is $message");
  }
}

class GeneralError extends Failure {
  GeneralError([String? error])
      : super(error ?? 'There was an Error, Please try again');
}

class ServerFailure extends Failure {
  ServerFailure(super.message);

  factory ServerFailure.fromDioError(DioException e) {
    Logger().e(e.response);
    if (e.response?.statusCode == 401) {
      print(e.error);
    }
    if (e.type == DioExceptionType.connectionError &&
        e.error is SocketException) {
      // providerContainer.read(hasInternetProvider2.notifier).state = false;
    }
    return switch (e.type) {
      DioExceptionType.badResponse => ServerFailure.fromResponse(e.response),
      _ => ServerFailure(e.message ?? e.response?.data),
    };
  }

  static String? getMessage(int? code) {
    switch (code) {
      case 400:
        return 'Bad Request';
      case 401:
        return "No active account found with the given credentials";
      case 403:
        return "You are not authorized to access this endpoint";
      case 404:
        return "The endpoint you are trying to access is not found";
      case 406:
        return "Code Expired or not correct";
      case 500:
        return "Something went wrong";
      case 503:
        return "Service is unavailable";
    }
    return null;
  }

  factory ServerFailure.fromResponse(Response<dynamic>? response) {
    logger.e(response);
    String? error;

    if (response?.data is Map) {
      if (response!.data?['errors'] != null &&
          response.data?['errors'] is String) {
        error = response.data?['errors'];
      } else if (response.data?['message'] != null &&
          response.data?['message'] is String) {
        error = response.data?['message'];
      } else {
        error = getMessage(response.statusCode) ?? response.data;
      }
    } else {
      error = getMessage(response?.statusCode) ?? response?.data;
    }

    return ServerFailure(error ?? "Something went wrong");
  }
}

abstract class Failure {
  final String message;

  Failure(this.message);

  @override
  String toString() {
    return message;
  }
}
