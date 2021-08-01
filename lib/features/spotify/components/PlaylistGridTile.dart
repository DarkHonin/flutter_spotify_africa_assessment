import 'package:flutter/material.dart';
import 'package:flutter_spotify_africa_assessment/features/spotify/api/Playlist.dart';
import 'package:flutter_spotify_africa_assessment/features/spotify/api/client.dart';
import 'package:flutter_spotify_africa_assessment/routes.dart';

class PlaylistGridTile extends StatelessWidget {
  final String categoryId, playlistId;
  const PlaylistGridTile(
      {Key? key, required this.categoryId, required this.playlistId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return FutureBuilder(
        future: SpotifyApiClient.getPlaylist(categoryId, playlistId),
        builder: (c, snap) {
          if (!snap.hasData) return Container();
          Playlist playlist = snap.data as Playlist;
          return GestureDetector(
              onTap: () => Navigator.pushNamed(
                  context, AppRoutes.spotifyPlaylist,
                  arguments: playlist),
              child: Container(
                width: (MediaQuery.of(c).size.width - 40) / 2,
                padding: EdgeInsets.all(12),
                child: Column(
                  children: [
                    Image(
                      fit: BoxFit.fitHeight,
                      image: NetworkImage(playlist.images.first.url),
                    ),
                    Container(
                        padding: EdgeInsets.all(4),
                        child: Text(
                          playlist.name,
                          style: theme.textTheme.headline6,
                        )),
                    Padding(
                        padding: EdgeInsets.all(4),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            playlist.followers.toString().replaceAllMapped(
                                    new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                                    (Match m) => '${m[1]},') +
                                " FOLLOWERS",
                            style: theme.textTheme.subtitle1,
                          ),
                        ))
                  ],
                ),
              ));
        });
  }
}
