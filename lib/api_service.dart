import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:nusantara/model.dart';

class ApiService {
  static Future<List<Province>> fetchProvinces() async {
    final response = await http.get(Uri.parse('https://www.emsifa.com/api-wilayah-indonesia/api/provinces.json'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((province) => Province.fromJson(province)).toList();
    } else {
      throw Exception('Failed to load provinces');
    }
  }

  static Future<List<Regency>> fetchRegencies(String provinceId) async {
    final response = await http.get(Uri.parse('https://www.emsifa.com/api-wilayah-indonesia/api/regencies/$provinceId.json'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((regency) => Regency.fromJson(regency)).toList();
    } else {
      throw Exception('Failed to load regencies');
    }
  }

  static Future<List<District>> fetchDistricts(String regencyId) async {
    final response = await http.get(Uri.parse('https://www.emsifa.com/api-wilayah-indonesia/api/districts/$regencyId.json'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((district) => District.fromJson(district)).toList();
    } else {
      throw Exception('Failed to load districts');
    }
  }
    static Future<List<Villages>> fetchVillages(String districtId) async {
    final response = await http.get(Uri.parse('https://www.emsifa.com/api-wilayah-indonesia/api/villages/$districtId.json'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((villages) => Villages.fromJson(villages)).toList();
    } else {
      throw Exception('Failed to load districts');
    }
  }
  
}
