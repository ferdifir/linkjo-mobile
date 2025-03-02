import 'dart:convert';

class Categories {
  final int id;
  final String name;
  final int? parentId;
  final List<Categories>? children;

  Categories({
    required this.id,
    required this.name,
    this.parentId,
    this.children,
  });

  // Factory method untuk parsing dari JSON
  factory Categories.fromJson(Map<String, dynamic> json) {
    return Categories(
      id: json['ID'],
      name: json['Name'],
      parentId: json['ParentID'],
      children: json['Children'] != null
          ? List<Categories>.from(
              json['Children'].map((x) => Categories.fromJson(x)))
          : null,
    );
  }

  // Method untuk mengonversi ke JSON
  Map<String, dynamic> toJson() {
    return {
      "ID": id,
      "Name": name,
      "ParentID": parentId,
      "Children": children != null
          ? List<dynamic>.from(children!.map((x) => x.toJson()))
          : null,
    };
  }

  // Method untuk mem-parsing list dari JSON
  static List<Categories> listFromJson(String str) {
    return List<Categories>.from(
        json.decode(str).map((x) => Categories.fromJson(x)));
  }
}
