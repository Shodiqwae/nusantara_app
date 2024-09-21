import 'package:flutter/material.dart';
import 'api_service.dart';
import 'package:nusantara/model.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? _selectedProvince;
  String? _selectedRegency;
  String? _selectedDistrict;
  String? _selectedVillages;

  List<Province> _provinces = [];
  List<Regency> _regencies = [];
  List<District> _districts = [];
  List<Villages> _villages = [];

  @override
  void initState() {
    super.initState();
    _loadProvinces();
  }

  void _loadProvinces() async {
    _provinces = await ApiService.fetchProvinces();
    setState(() {});
  }

  void _loadRegencies(String provinceId) async {
    _regencies = await ApiService.fetchRegencies(provinceId);
    setState(() {});
  }

  void _loadDistricts(String regencyId) async {
    _districts = await ApiService.fetchDistricts(regencyId);
    setState(() {});
  }

  void _loadVillages(String districtId) async {
    _villages = await ApiService.fetchVillages(districtId);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Wilayah Indonesia'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButton<String>(
              hint: Text("Pilih Provinsi"),
              value: _selectedProvince,
              onChanged: (newValue) {
                setState(() {
                  _selectedProvince = newValue;
                  _selectedRegency = null;
                  _selectedDistrict = null;
                  _selectedVillages = null;
                  _regencies = [];
                  _districts = [];
                  _villages = [];
                  if (newValue != null) {
                    _loadRegencies(newValue);
                  }
                });
              },
              items: _provinces.map((province) {
                return DropdownMenuItem<String>(
                  value: province.id,
                  child: Text(province.name),
                );
              }).toList(),
            ),
            if (_regencies.isNotEmpty)
              DropdownButton<String>(
                hint: Text("Pilih Kabupaten"),
                value: _selectedRegency,
                onChanged: (newValue) {
                  setState(() {
                    _selectedRegency = newValue;
                    _selectedDistrict = null;
                    _selectedVillages = null;
                    _districts = [];
                    _villages = [];
                    if (newValue != null) {
                      _loadDistricts(newValue);
                    }
                  });
                },
                items: _regencies.map((regency) {
                  return DropdownMenuItem<String>(
                    value: regency.id,
                    child: Text(regency.name),
                  );
                }).toList(),
              ),
            if (_districts.isNotEmpty)
              DropdownButton<String>(
                hint: Text("Pilih Kecamatan"),
                value: _selectedDistrict,
                onChanged: (newValue) {
                  setState(() {
                    _selectedDistrict = newValue;
                    _selectedVillages = null;
                    _villages = [];
                    if (newValue != null) {
                      _loadVillages(newValue);
                    }
                  });
                },
                items: _districts.map((district) {
                  return DropdownMenuItem<String>(
                    value: district.id,
                    child: Text(district.name),
                  );
                }).toList(),
              ),
            if (_villages.isNotEmpty)
              DropdownButton<String>(
                hint: Text("Pilih Kelurahan"),
                value: _selectedVillages,
                onChanged: (newValue) {
                  setState(() {
                    _selectedVillages = newValue;
                  });
                },
                items: _villages.map((villages) {
                  return DropdownMenuItem<String>(
                    value: villages.id,
                    child: Text(villages.name),
                  );
                }).toList(),
              ),
          ],
        ),
      ),
    );
  }
}