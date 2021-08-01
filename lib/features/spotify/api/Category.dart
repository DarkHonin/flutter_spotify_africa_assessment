import './SpotifyIcon.dart';

class Category {
  late String id;
  late String href;
  late String name;
  late List<SpotifyIcon> icons = [];

  Category.fromJson(Map<String, dynamic> json) {
    this.id = json['id'] as String;
    this.href = json['href'] as String;
    this.name = json['name'] as String;

    List<dynamic> rawIcons = json['icons'];
    icons = rawIcons.map((e) => SpotifyIcon.fromJson(e)).toList();
  }

  Category({required this.id, required this.href});
}
