import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_spotify_africa_assessment/features/spotify/api/Artist.dart';

import 'package:flutter_spotify_africa_assessment/features/spotify/api/Playlist.dart';
import 'package:flutter_spotify_africa_assessment/features/spotify/api/Track.dart';
import 'package:flutter_spotify_africa_assessment/features/spotify/components/TrackList.dart';
import 'package:flutter_spotify_africa_assessment/features/spotify/components/TrackSearchBar.dart';
import 'package:flutter_spotify_africa_assessment/colors.dart';
import 'dart:math';
import 'package:html/parser.dart';

import 'package:flutter_spotify_africa_assessment/features/spotify/api/client.dart';

//TODO: complete this page - you may choose to change it to a stateful widget if necessary
class SpotifyPlaylist extends StatelessWidget {
  final Playlist playlist;
  const SpotifyPlaylist({Key? key, required this.playlist}) : super(key: key);

  String _parseText(String raw) {
    final body = parse(raw).body;
    final String parsedString = parse(body!.text).documentElement!.text;
    return parsedString;
  }

  String _parseTime(int ms) {
    int min = (((ms / 1000) / 60)).floor();
    int hrs = (min / 60).floor();
    min = min % 60;

    String ret = '-';
    if (hrs > 0) ret = '${ret} ${hrs}h ';
    ret = '${ret} ${min}min';

    return ret;
  }

  @override
  Widget build(BuildContext context) {
    TextStyle durationStyle = TextStyle(color: AppColors.green);
    TextStyle descriptionStyle = TextStyle(fontSize: 12);
    ThemeData theme = Theme.of(context);

    int duration = 0;
    Map<String, num> artists = Map<String, int>();

    // Tally duration and tracks a spesific artist features in
    playlist.tracks.map((e) {
      duration += e.duration;
      for (TrackArtist artistTrack in e.artists) {
        if (!artists.containsKey(artistTrack.id)) artists[artistTrack.id] = 1;
        artists[artistTrack.id] = artists[artistTrack.id]! + 1;
      }
      ;
    }).toList();

    // Sort artist Ids based on feature count
    final sorted = new SplayTreeMap<String, num>.from(
        artists, (a, b) => artists[a]! > artists[b]! ? -1 : 1);

    return Scaffold(
      appBar: AppBar(),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TrackSearchBar(),
            Expanded(
                child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(14),
                    child: Center(
                        child: SizedBox(
                            width: 265,
                            height: 265,
                            child: Image(
                              image: NetworkImage(playlist.images.first.url),
                            ))),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      _parseText(playlist.description),
                      style: descriptionStyle,
                    ),
                  ),
                  Row(
                    children: [
                      Text(playlist.followers.toString().replaceAllMapped(
                              new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                              (Match m) => '${m[1]},') +
                          " likes "),
                      Text(
                        _parseTime(duration),
                        style: durationStyle,
                      )
                    ],
                  ),
                  TrackList(tracks: playlist.tracks),
                  Text("Artists in this playlist:",
                      style: theme.textTheme.headline6),
                  SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: sorted.keys
                            .map((id) => FutureBuilder(
                                future: SpotifyApiClient.getArtist(id),
                                builder: (c, snapC) {
                                  if (snapC.hasError) return Container();
                                  if (!snapC.hasData)
                                    return CircularProgressIndicator();
                                  Artist artist = snapC.data as Artist;
                                  return Padding(
                                      padding: EdgeInsets.all(14),
                                      child: Column(
                                        children: [
                                          Container(
                                              child: CircleAvatar(
                                                foregroundImage: NetworkImage(
                                                    artist.icon.url),
                                              ),
                                              width: 130,
                                              height: 130),
                                          Text(artist.name),
                                        ],
                                      ));
                                }))
                            .toList(),
                      ))
                ],
              ),
            ))
          ],
        ),
      ),
    );
  }
}
