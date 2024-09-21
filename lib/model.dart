class Province {
  final String id;
  final String name;

  Province({required this.id, required this.name});

  factory Province.fromJson(Map<String, dynamic> json) {
    return Province(
      id: json['id'],
      name: json['name'],
    );
  }
}

class Regency {
  final String id;
  final String name;

  Regency({required this.id, required this.name});

  factory Regency.fromJson(Map<String, dynamic> json) {
    return Regency(
      id: json['id'],
      name: json['name'],
    );
  }
}

class District {
  final String id;
  final String name;

  District({required this.id, required this.name});

  factory District.fromJson(Map<String, dynamic> json) {
    return District(
      id: json['id'],
      name: json['name'],
    );
  }
}

class Villages {
  final String id;
  final String name;

  Villages({required this.id, required this.name});

  factory Villages.fromJson(Map<String, dynamic> json) {
    return Villages(
      id: json['id'],
      name: json['name'],
    );
  }
}
