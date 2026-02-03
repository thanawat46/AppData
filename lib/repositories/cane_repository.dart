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
        try {
          final response = await _dio.get('/transectionview/$id', cancelToken: token);

          if (response.statusCode == 200 && response.data['success'] != false) {
            final List<dynamic> list = response.data['data'] ?? [];
            return list.map((e) => CaneData.fromJson(e)).toList();
          }
          throw Exception(response.data['message'] ?? 'Server Error');
        } catch (e) {
          _handleError(e);
          return [];
        }
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
    } catch (e) {
      _handleError(e);
      return [];
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
    } catch (e) {
      _handleError(e);
      return [];
    }
  }

  Future<List<RobshowData>> getQueueStatus([String typeId = "0"]) async {
    try {
      final response = await _dio.get('/robshow/$typeId');

      if (response.statusCode == 200 && response.data['success'] == true) {
        final List<dynamic> rawList = response.data['data'] ?? [];
        return rawList.map((e) => RobshowData.fromJson(e)).toList();
      } else {
        return [];
      }
    } catch (e) {
      print('Error fetching queue: $e');
      return [];
    }
  }

  void _handleError(Object e) {
    if (e is DioException) {
      if (CancelToken.isCancel(e)) return;

      switch (e.type) {
        case DioExceptionType.connectionTimeout:
          throw Exception("เชื่อมต่อช้าเกินไป กรุณาลองใหม่");
        case DioExceptionType.connectionError:
          throw Exception("ไม่พบสัญญาณอินเทอร์เน็ต");
        case DioExceptionType.badResponse:
          throw Exception("Server Error (${e.response?.statusCode}): ${e.response?.data['message'] ?? ''}");
        default:
          throw Exception("เครือข่ายขัดข้อง: ${e.message}");
      }
    }
    throw Exception("เกิดข้อผิดพลาด: $e");
  }
}

class AuthService {
  final Dio _dio = Dio();

  Future<Map<String, dynamic>?> loginWithEncryptedData(String encryptedBase64) async {
    const String url = 'http://110.164.149.104:9198/ccs/signin';
    try {
      var data = json.encode({"codestr": encryptedBase64});
      final response = await _dio.post(url, data: data);

      if (response.statusCode == 200) return response.data;
      return null;
    } catch (e) {
      return null;
    }
  }
}