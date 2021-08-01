import './SpotifyIcon.dart';
import './Track.dart';

class Playlist {
  final String description, name, id;
  final int followers;
  final List<SpotifyIcon> images;
  final List<Track> tracks;

  Playlist(this.id, this.name, this.description, this.images, this.followers,
      this.tracks) {}

  static Playlist fromJson(Map<String, dynamic> json) {
    String id = json['id'] as String;
    String name = json['name'] as String;
    String description = json['description'] as String;

    int followers = json['followers'] != Null ? json['followers']['total'] : 0;

    List<dynamic> rawIcons = json['images'];
    List<SpotifyIcon> images =
        rawIcons.map((e) => SpotifyIcon.fromJson(e)).toList();

    List<dynamic> rawTracks = json['tracks']['items'];

    List<Track> tracks = [];
    for (Map<String, dynamic> e in rawTracks) {
      if (e != Null && e['track'] != Null)
        tracks.add(Track.fromJson(e['track']));
    }

    return Playlist(id, name, description, images, followers, tracks);
  }
}
