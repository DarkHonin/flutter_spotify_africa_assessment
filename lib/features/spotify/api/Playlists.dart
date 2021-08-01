import './SpotifyIcon.dart';

class Playlists {
  late String href;
  late List<PlaylistSummary> items = [];

  Playlists.fromJson(Map<String, dynamic> json) {
    href = json['href'] as String;
    List<dynamic> rawPlaylistItems = json['items'];
    items = rawPlaylistItems.map((e) => PlaylistSummary.fromJson(e)).toList();
  }
}

class PlaylistSummary {
  final String id, name;
  final List<SpotifyIcon> images;

  PlaylistSummary(this.id, this.name, this.images);

  static PlaylistSummary fromJson(Map<String, dynamic> json) {
    String id = json['id'] as String;
    String name = json['name'] as String;
    // print(json['icons']);
    List<dynamic> rawIcons = json['images'];
    List<SpotifyIcon> images =
        rawIcons.map((e) => SpotifyIcon.fromJson(e)).toList();

    return PlaylistSummary(id, name, images);
  }
}
