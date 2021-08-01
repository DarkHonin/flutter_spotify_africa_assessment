import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spotify_africa_assessment/features/spotify/api/Playlist.dart';
import 'package:flutter_spotify_africa_assessment/features/spotify/api/Playlists.dart';
import 'package:flutter_spotify_africa_assessment/features/spotify/api/client.dart';
import 'package:flutter_spotify_africa_assessment/routes.dart';

import './PlaylistGridTile.dart';

class PlaylistGrid extends StatefulWidget {
  final String categoryId;
  const PlaylistGrid({Key? key, required this.categoryId}) : super(key: key);

  @override
  _PlaylistGridState createState() => _PlaylistGridState();
}

class _PlaylistGridState extends State<PlaylistGrid> {
  int page = 0, limit = 5;
  @override
  Widget build(BuildContext context) {
    Future<Playlists> playlists = SpotifyApiClient.getPlaylists(
        widget.categoryId,
        offset: page * limit,
        limit: limit);
    ThemeData theme = Theme.of(context);
    return FutureBuilder(
        future: playlists,
        builder: (c, snap) {
          if (snap.hasError) {
            print(snap.error);
            return Center(child: Text("Something went wrong"));
          }
          if (!snap.hasData) return Center(child: CircularProgressIndicator());

          Playlists pp = snap.data as Playlists;

          return Column(
            children: [
              Wrap(
                // crossAxisCount: 2,
                // mainAxisSpacing: 16,
                // crossAxisSpacing: 16,
                // childAspectRatio: 0.8,
                children: pp.items
                    .map((e) => PlaylistGridTile(
                        categoryId: widget.categoryId, playlistId: e.id))
                    // .map((e) => Container(
                    //     width: 200,
                    //     height: 200,
                    //     color: Colors.green,
                    //     padding: EdgeInsets.all(16)))
                    .toList(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                      onPressed: () =>
                          setState(() => page > 0 ? page -= 1 : page = page),
                      icon: Icon(Icons.chevron_left)),
                  Text((page + 1).toString()),
                  IconButton(
                      onPressed: () => setState(() => page += 1),
                      icon: Icon(Icons.chevron_right))
                ],
              )
            ],
          );
        });
  }
}
