class SpotifyIcon {
  late String url;

  SpotifyIcon.fromJson(Map<String, dynamic> json) {
    this.url = json['url'] as String;
  }
}
