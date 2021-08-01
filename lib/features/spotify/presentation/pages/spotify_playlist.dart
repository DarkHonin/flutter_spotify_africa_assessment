import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_spotify_africa_assessment/features/spotify/api/Artist.dart';

import 'package:flutter_spotify_africa_assessment/features/spotify/api/Playlist.dart';
import 'package:flutter_spotify_africa_assessment/features/spotify/api/Track.dart';
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
    ThemeData theme = Theme.of(context);

    int duration = 0;
    List<TrackArtist> artists = [];
    List<ListTile> tracks = playlist.tracks.map((e) {
      duration += e.duration;
      bool has = false;
      for (TrackArtist a in artists) if (a.id == e.artists.first.id) has = true;

      if (!has) artists.add(e.artists.first);
      return ListTile(
          leading: Image(image: NetworkImage(e.albumArt.url)),
          title:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(e.name),
            Text(e.artists.first.name, style: theme.textTheme.subtitle2),
            Text(e.durationString(), style: durationStyle)
          ]));
    }).toList();

    return Scaffold(
      appBar: AppBar(),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TrackSearchBar(onSearch: (v) {
              print(v);
            }),
            Expanded(
                child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                      child: SizedBox(
                          width: 400,
                          height: 400,
                          child: Image(
                            image: NetworkImage(playlist.images.first.url),
                          ))),
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(_parseText(playlist.description)),
                  ),
                  Row(
                    children: [
                      Text(playlist.followers.toString().replaceAllMapped(
                              new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                              (Match m) => '${m[1]},') +
                          " likes"),
                      Text(
                        _parseTime(duration),
                        style: durationStyle,
                      )
                    ],
                  ),
                  ...tracks.sublist(0, 3),
                  Text("Artists in this playlist:",
                      style: theme.textTheme.headline6),
                  SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: artists
                            .map((e) => FutureBuilder(
                                future: SpotifyApiClient.getArtist(e.id),
                                builder: (c, snapC) {
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
                                              width: 200,
                                              height: 200),
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
