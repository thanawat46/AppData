import 'dart:convert';
import 'package:dio/dio.dart';
import '../models/data_model.dart';
import '../utils/smart_resource.dart';

class CaneRepository {
  final Dio _dio;

  final _transactionsRes = SmartResource<List<CaneData>>();

  CaneRepository({Dio? dio}) : _dio = dio ?? Dio() {
    _dio.options.baseUrl = 'http://110.164.149.104:9198/ccs';
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