import 'dart:convert';
import 'package:dio/dio.dart';
import '../models/data_model.dart';
import '../utils/smart_resource.dart';

class CaneRepository {
  final Dio _dio;
  final _transactionsRes = SmartResource<List<CaneData>>();

  CaneRepository({Dio? dio}) : _dio = dio ?? Dio() {
    _dio.options.baseUrl = 'http://110.164.149.104:9198/ccs';
    _dio.options.connectTimeout = const Duration(seconds: 10);
  }

  Future<List<CaneData>> getCaneTransactions(String id, {bool forceRefresh = false}) {
    return _transactionsRes.getOrFetch(
      forceRefresh: forceRefresh,
      fetcher: (token) async {
        final response = await _dio.get('/transectionview/$id', cancelToken: token);

        if (response.statusCode == 200 && response.data['success'] != false) {
          final List<dynamic> list = response.data['data'] ?? [];
          return list.map((e) => CaneData.fromJson(e)).toList();
        }
        throw Exception('Server Error');
      },
    );
  }

  Future<List<CaneYear>> getCaneYears() async {
    try {
      final response = await _dio.get('/year');
      if (response.statusCode == 200 && response.data['success'] == true) {
        final List<dynamic> rawList = response.data['data'] ?? [];
        return rawList.map((e) => CaneYear.fromJson(e)).toList();
      } else {
        throw Exception(response.data['message'] ?? 'เกิดข้อผิดพลาดในการดึงข้อมูล');
      }
    } on DioException catch (e) {
      throw Exception('Network Error: ${e.message}');
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<List<PromotionData>> getPromotionItems(String userId) async {
    try {
      final response = await _dio.get('/item2year/$userId');

      if (response.statusCode == 200 && response.data['success'] == true) {
        final List<dynamic> rawList = response.data['data'] ?? [];
        return rawList.map((e) => PromotionData.fromJson(e)).toList();
      } else {
        throw Exception(response.data['message'] ?? 'เกิดข้อผิดพลาดจาก Server');
      }
    } on DioException catch (e) {
      String message = "เชื่อมต่อเซิร์ฟเวอร์ไม่ได้";
      if (e.type == DioExceptionType.connectionTimeout) message = "หมดเวลาการเชื่อมต่อ";
      throw Exception(message);
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}

class AuthService {
  final Dio _dio = Dio();

  Future<Map<String, dynamic>?> loginWithEncryptedData(String encryptedBase64) async {
    const String url = 'http://110.164.149.104:9198/ccs/signin';

    try {
      var data = json.encode({
        "codestr": encryptedBase64
      });

      final response = await _dio.post(
        url,
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
        data: data,
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        print("Server Error: ${response.statusMessage}");
        return null;
      }
    } catch (e) {
      print("Connection Error: $e");
      return null;
    }
  }
}

