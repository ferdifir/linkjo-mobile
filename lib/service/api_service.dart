import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:linkjo/model/api_response.dart';
import 'package:linkjo/service/hive_service.dart';
import 'package:linkjo/utils/hive_key.dart';
import 'package:linkjo/utils/log.dart';

class ApiService {
  final String _baseUrl = 'http://192.168.1.8:8080';

  Future<ApiResponse> get(String endpoint) async {
    try {
      final Uri url = Uri.parse('$_baseUrl$endpoint');
      final response = await http.get(url, headers: _headers());
      return _handleResponse(response);
    } catch (e) {
      Log.d(e);
      return ApiResponse(success: false, message: "Failed to connect: $e");
    }
  }

  Future<ApiResponse> post(String endpoint, Map<String, dynamic> data) async {
    try {
      final Uri url = Uri.parse('$_baseUrl$endpoint');
      final response = await http.post(
        url,
        headers: _headers(),
        body: jsonEncode(data),
      );

      return _handleResponse(response);
    } catch (e) {
      return ApiResponse(success: false, message: "Failed to connect: $e");
    }
  }

  Future<ApiResponse> postMultiFile(
    String endpoint,
    Map<String, dynamic> data,
    List<String> imgKeys,
  ) async {
    try {
      final Uri url = Uri.parse('$_baseUrl$endpoint');
      final request = http.MultipartRequest('POST', url);

      request.headers.addAll(_headers(isFile: true));

      data.forEach((key, value) {
        if (!imgKeys.contains(key)) {
          request.fields[key] = value.toString();
        }
      });

      for (var key in imgKeys) {
        if (data[key] != null && data[key] is String) {
          File file = File(data[key]);
          if (await file.exists()) {
            request.files.add(
              await http.MultipartFile.fromPath(
                key,
                data[key],
                contentType: _getContentType(data[key]),
              ),
            );
          } else {
            Log.d("File tidak ditemukan: ${data[key]}");
          }
        } else {
          Log.d("Path gambar tidak valid untuk field $key");
        }
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      Log.d(response.body);
      return _handleResponse(response);
    } catch (e) {
      Log.d("Error: $e");
      return ApiResponse(success: false, message: "Failed to connect: $e");
    }
  }

  Future<ApiResponse> put(String endpoint, Map<String, dynamic> data) async {
    try {
      final Uri url = Uri.parse('$_baseUrl$endpoint');
      final response = await http.put(
        url,
        headers: _headers(),
        body: jsonEncode(data),
      );

      return _handleResponse(response);
    } catch (e) {
      return ApiResponse(success: false, message: "Failed to connect: $e");
    }
  }

  Future<dynamic> delete(String endpoint) async {
    try {
      final Uri url = Uri.parse('$_baseUrl$endpoint');
      final response = await http.delete(url, headers: _headers());

      return _handleResponse(response);
    } catch (e) {
      return {"error": "Failed to connect: $e"};
    }
  }

  Map<String, String> _headers({bool isFile = false}) {
    String token = HiveService.getData(HiveKey.token, defaultValue: '');
    var header = {
      "Accept": "application/json",
    };

    if (!isFile) {
      header["Content-Type"] = "application/json";
    }

    if (token.isNotEmpty) {
      header['Authorization'] = "Bearer $token";
    }

    return header;
  }

  MediaType _getContentType(String filePath) {
    if (filePath.toLowerCase().endsWith(".jpg") ||
        filePath.toLowerCase().endsWith(".jpeg")) {
      return MediaType("image", "jpeg");
    } else if (filePath.toLowerCase().endsWith(".png")) {
      return MediaType("image", "png");
    } else {
      return MediaType("application", "octet-stream");
    }
  }

  ApiResponse _handleResponse(http.Response response) {
    if (response.statusCode == 401) {
      return ApiResponse(
        success: false,
        message: "Unauthorized",
      );
    }
    if (response.statusCode >= 200 && response.statusCode < 300) {
      final data = jsonDecode(response.body);
      return ApiResponse.fromJson(data);
    } else {
      return ApiResponse(
        success: false,
        message: "Failed to connect: ${response.statusCode}",
      );
    }
  }
}
