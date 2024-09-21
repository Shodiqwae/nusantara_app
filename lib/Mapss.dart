import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'package:nusantara/model.dart';
import 'api_service.dart'; // Ensure this imports your ApiService class

class LocationMapPage extends StatefulWidget {
  @override
  _LocationMapPageState createState() => _LocationMapPageState();
}

class _LocationMapPageState extends State<LocationMapPage> {
  MapController _mapController = MapController();

  List<Province> provinces = [];
  List<Regency> regencies = [];
  List<District> districts = [];
  List<Villages> villages = [];

  Province? selectedProvince;
  Regency? selectedRegency;
  District? selectedDistrict;
  Villages? selectedVillage;

  LatLng currentLocation = LatLng(-6.175110, 106.865039); // Default: Jakarta

  @override
  void initState() {
    super.initState();
    _fetchProvinces();
  }

  void _fetchProvinces() async {
    try {
      final fetchedProvinces = await ApiService.fetchProvinces();
      setState(() {
        provinces = fetchedProvinces;
      });
    } catch (e) {
      print('Failed to load provinces: $e');
    }
  }

  void _fetchRegencies(String provinceId) async {
    try {
      final fetchedRegencies = await ApiService.fetchRegencies(provinceId);
      setState(() {
        regencies = fetchedRegencies;
        selectedRegency = null;
        selectedDistrict = null;
        selectedVillage = null;
        districts = [];
        villages = [];
      });
    } catch (e) {
      print('Failed to load regencies: $e');
    }
  }

  void _fetchDistricts(String regencyId) async {
    try {
      final fetchedDistricts = await ApiService.fetchDistricts(regencyId);
      setState(() {
        districts = fetchedDistricts;
        selectedDistrict = null;
        selectedVillage = null;
        villages = [];
      });
    } catch (e) {
      print('Failed to load districts: $e');
    }
  }

  void _fetchVillages(String districtId) async {
    try {
      final fetchedVillages = await ApiService.fetchVillages(districtId);
      setState(() {
        villages = fetchedVillages;
        selectedVillage = null;
      });
    } catch (e) {
      print('Failed to load villages: $e');
    }
  }

  Future<LatLng?> _getCoordinates(String placeName) async {
    final url =
        'https://nominatim.openstreetmap.org/search?format=json&q=${Uri.encodeComponent(placeName)}';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data.isNotEmpty) {
          final lat = double.parse(data[0]['lat']);
          final lon = double.parse(data[0]['lon']);
          return LatLng(lat, lon);
        }
      }
    } catch (e) {
      print('Failed to get coordinates: $e');
    }
    return null;
  }

  void _onLocationChange() async {
    String? placeName;
    if (selectedVillage != null) {
      placeName = selectedVillage!.name;
    } else if (selectedDistrict != null) {
      placeName = selectedDistrict!.name;
    } else if (selectedRegency != null) {
      placeName = selectedRegency!.name;
    } else if (selectedProvince != null) {
      placeName = selectedProvince!.name;
    }
    if (placeName != null) {
      LatLng? location = await _getCoordinates(placeName);
      if (location != null) {
        setState(() {
          currentLocation = location;
        });
        _mapController.move(location, 13); // Update map position
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('NusantaraMaps', style: TextStyle(color: Colors.white ),)),
      body: Column(
        children: [
          // Dropdown for Provinces
          Container(
            height: 50,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                Row(
                  children: [
                    Container(
                       margin: EdgeInsets.only(left: 20),
                      child: DropdownButton<Province>(
                        hint: Text(
                          'Pilih Provinsi',
                          style: TextStyle(fontSize: 15),
                        ),
                        value: selectedProvince,
                        items: provinces.map((province) {
                          return DropdownMenuItem<Province>(
                            value: province,
                            child: Text(
                              province.name,
                              style: TextStyle(fontSize: 15),
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedProvince = value;
                            if (value != null) {
                              _fetchRegencies(value.id);
                              _onLocationChange(); // Update map when province is selected
                            }
                          });
                        },
                      ),
                    ),
                    // Dropdown for Regencies (Kota/Kabupaten)
                    if (regencies.isNotEmpty)
                      DropdownButton<Regency>(
                        hint: Text(
                          'Pilih Kota/Kabupaten',
                          style: TextStyle(fontSize: 15),
                        ),
                        value: selectedRegency,
                        items: regencies.map((regency) {
                          return DropdownMenuItem<Regency>(
                            value: regency,
                            child: Text(
                              regency.name,
                              style: TextStyle(fontSize: 15),
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedRegency = value;
                            if (value != null) {
                              _fetchDistricts(value.id);
                              _onLocationChange(); // Update map when regency is selected
                            }
                          });
                        },
                      ),
                    // Dropdown for Districts (Kecamatan)
                    if (districts.isNotEmpty)
                      DropdownButton<District>(
                        hint: Text(
                          'Pilih Kecamatan',
                          style: TextStyle(fontSize: 15),
                        ),
                        value: selectedDistrict,
                        items: districts.map((district) {
                          return DropdownMenuItem<District>(
                            value: district,
                            child: Text(
                              district.name,
                              style: TextStyle(fontSize: 15),
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedDistrict = value;
                            if (value != null) {
                              _fetchVillages(value.id);
                              _onLocationChange(); // Update map when district is selected
                            }
                          });
                        },
                      ),
                    // Dropdown for Villages (Kelurahan/Desa)
                    if (villages.isNotEmpty)
                      DropdownButton<Villages>(
                        hint: Text(
                          'Pilih Kelurahan/Desa',
                          style: TextStyle(fontSize: 15),
                        ),
                        value: selectedVillage,
                        items: villages.map((village) {
                          return DropdownMenuItem<Villages>(
                            value: village,
                            child: Text(
                              village.name,
                              style: TextStyle(fontSize: 15),
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedVillage = value;
                            _onLocationChange(); // Update map when village is selected
                          });
                        },
                      ),
                  ],
                ),
              ],
            ),
          ),
          // Flutter Map Widget
          Expanded(
            child: FlutterMap(
  mapController: _mapController,
  options: MapOptions(
    initialCenter: currentLocation,
    initialZoom: 13,
  ),
  children: [
    TileLayer(
      urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
      subdomains: ['a', 'b', 'c'],
    ),
   MarkerLayer(
  markers: [
    Marker(
      point: currentLocation,
      width: 80,
      height: 80,
      child:  Icon(
        Icons.location_on,
        color: Colors.red,
        size: 40,
      ),
    ),
  ],
),

  ],
)

          ),
        ],
      ),
    );
  }
}
