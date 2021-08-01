import 'package:flutter_spotify_africa_assessment/features/spotify/api/SpotifyIcon.dart';

class Artist {
  String id, name;

  SpotifyIcon icon;

  Artist(this.id, this.name, this.icon);

  static Artist fromJson(Map<String, dynamic> json) {
    String id = json['id'];
    String name = json['name'];
    SpotifyIcon icon = SpotifyIcon.fromJson(json['images'][0]);
    return Artist(id, name, icon);
  }
}
