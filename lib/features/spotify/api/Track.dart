import './SpotifyIcon.dart';
import './client.dart';

class TrackArtist {
  String name, id;
  TrackArtist(this.id, this.name);
}

class Track {
  int duration;
  String id, name;
  SpotifyIcon albumArt;
  List<TrackArtist> artists;

  Track(this.id, this.name, this.duration, this.albumArt, this.artists);

  static Track fromJson(Map<String, dynamic> json) {
    // print(json);
    String id = json['id'];
    String name = json['name'];
    int duration = json['duration_ms'];

    SpotifyIcon albumArt = SpotifyIcon.fromJson(json['album']['images'][0]);
    List<TrackArtist> artists = (json['artists'] as List<dynamic>)
        .map((e) => TrackArtist(e['id'], e['name']))
        .toList();

    return Track(id, name, duration, albumArt, artists);
  }

  String durationString() {
    int min, sec;
    min = ((duration / 1000) / 60).floor();
    sec = ((duration / 1000) - (min * 60)).floor();

    return "${min}:${sec}";
  }
}
