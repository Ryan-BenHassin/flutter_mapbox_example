import 'dart:io';

import '../models/complex.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ComplexService {
  final String baseUrl = Platform.isAndroid 
      ? 'http://10.0.2.2:1337/api'
      : 'http://localhost:1337/api';

  Future<List<Complex>> fetchComplexes() async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/complexes"));
      
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        final List<dynamic> complexesData = jsonResponse['data'];
        
        return complexesData.map((complex) {
          final address = complex['address'];
          return Complex(
            id: complex['id'],
            documentId: complex['documentId'],
            name: complex['title'] ?? '',
            // Use address if available, otherwise default to 0,0
            latitude: address?['latitude']?.toDouble() ?? 0.0,
            longitude: address?['longitude']?.toDouble() ?? 0.0,
            description: 'ID: ${complex['documentId']}',
          );
        }).toList();
      } else {
        throw Exception('Failed to load complexes: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching complexes: $e');
      return [];
    }
  }
}
