import 'package:dio/dio.dart';
import '../models/cane_data_model.dart';
import '../utils/smart_resource.dart';

class CaneRepository {
  final Dio _dio;

  final _transactionsRes = SmartResource<List<CaneData>>();

  CaneRepository({Dio? dio}) : _dio = dio ?? Dio() {
    _dio.options.baseUrl = 'http://110.164.149.104:91/crapi';
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