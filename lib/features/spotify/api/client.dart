import 'dart:io';

import 'package:flutter_spotify_africa_assessment/features/spotify/api/Artist.dart';
import 'package:http/http.dart' as http;

import './Category.dart';
import 'Playlists.dart';
import 'Playlist.dart';
import 'dart:convert';

class SpotifyApiClient {
  static const API_URL =
      "https://palota-jobs-africa-spotify-fa.azurewebsites.net/api";
  static const API_KEY =
      "BwtKHT3o5eAQ98LX8tS8wrrKNWXWT1EIx9Mj5Vbano5MmWYCvagnuw==";

  static Future<Category> getCategory(String category) async {
    var res = await http.get(
        Uri.parse('${API_URL}/browse/categories/${category}'),
        headers: {'x-functions-key': API_KEY});
    print(res.statusCode);
    return Category.fromJson(jsonDecode(res.body));
  }

  static Future<Playlists> getPlaylists(String category,
      {limit = 20, offset = 0}) async {
    var res = await http.get(
        Uri.parse(
            '${API_URL}/browse/categories/${category}/playlists?limit=${limit.toString()}&offset=${offset.toString()}'),
        headers: {'x-functions-key': API_KEY});
    Map<String, dynamic> json = jsonDecode(res.body);
    // List<Playlist> pls = (json['playlists']['items'] as List<dynamic>)
    //     .map((e) => Playlist.fromJson(e))
    //     .toList();

    // print(pls.isEmpty ? "Got something" : "This bitch empty");
    // Map<String, dynamic> json = ;
    return Playlists.fromJson(json['playlists']);
  }

  static Future<Playlist> getPlaylist(
      String category, String playlistId) async {
    var res = await http.get(Uri.parse('${API_URL}/playlists/${playlistId}'),
        headers: {'x-functions-key': API_KEY});
    Map<String, dynamic> json = jsonDecode(res.body);
    return Playlist.fromJson(json);
  }

  static Future<Artist> getArtist(String artistId) async {
    var res = await http.get(Uri.parse('${API_URL}/artists/${artistId}'),
        headers: {'x-functions-key': API_KEY});
    Map<String, dynamic> json = jsonDecode(res.body);

    return Artist.fromJson(json);
  }
}
