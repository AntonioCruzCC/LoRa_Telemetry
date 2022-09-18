class District {
  String id;
  String name;

  District({
    required this.id,
    required this.name,
  });

  District.fromJson(String id, Map<String, Object?> json)
      : this(id: id, name: json['Name']!.toString());

  Map<String, Object?> toJson() {
    return {
      'Name': name,
    };
  }

  @override
  bool operator ==(covariant District other) {
    return other.id == id && other.name == name;
  }

  @override
  int get hashCode => Object.hash(id, name);
}
