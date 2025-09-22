import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:eventsource/eventsource.dart';
import '../models/shoe_model.dart';

class ShoeService {
  static const String _baseUrl = 'http://10.0.2.2:3000/api';
  
  EventSource? _eventSource;
  StreamController<List<ShoeModel>>? _streamController;

  Stream<List<ShoeModel>> get updates => _streamController!.stream;

  void startListening() {
    _streamController = StreamController<List<ShoeModel>>.broadcast();
    
    final uri = Uri.parse('$_baseUrl/updates');
    final client = http.Client();
    
    void handleLine(String line) {
      if (line.startsWith('data: ')) {
        final data = line.substring(6);
        final jsonList = json.decode(data) as List;
        final shoes = jsonList.map((json) => ShoeModel.fromJson(json)).toList();
        _streamController?.add(shoes);
      }
    }

    client.send(http.Request('GET', uri)..headers['Accept'] = 'text/event-stream')
      .then((response) {
        response.stream
          .transform(utf8.decoder)
          .transform(const LineSplitter())
          .listen(handleLine);
      });
  }

  void dispose() {
    _streamController?.close();
    _streamController = null;
  } // Use 10.0.2.2 to access localhost from Android emulator

  Future<List<ShoeModel>> getShoes({String? keyword}) async {
    try {
      final queryParams = keyword != null && keyword.isNotEmpty
          ? {'keyword': keyword}
          : null;

      final uri = Uri.parse('$_baseUrl/shoes').replace(queryParameters: queryParams);
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => ShoeModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load shoes');
      }
    } catch (e) {
      throw Exception('Error fetching shoes: $e');
    }
  }

  Future<ShoeModel> getShoeDetails(String id) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/shoes/$id'),
      );

      if (response.statusCode == 200) {
        return ShoeModel.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load shoe details');
      }
    } catch (e) {
      throw Exception('Error fetching shoe details: $e');
    }
  }

  // Helper method to get the full image URL
  static String getImageUrl(String imageName) {
    return 'http://10.0.2.2:3000/uploads/$imageName';
  }
}