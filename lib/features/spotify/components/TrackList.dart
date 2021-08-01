import 'package:flutter/material.dart';
import 'package:flutter_spotify_africa_assessment/features/spotify/api/Track.dart';
import 'package:flutter_spotify_africa_assessment/features/spotify/components/TrackSearchBar.dart';
import 'package:flutter_spotify_africa_assessment/colors.dart';

class TrackList extends StatefulWidget {
  final List<Track> tracks;
  const TrackList({Key? key, required this.tracks}) : super(key: key);

  @override
  _TrackListState createState() => _TrackListState();
}

class _TrackListState extends State<TrackList> {
  @override
  Widget build(BuildContext context) {
    TextStyle durationStyle = TextStyle(color: AppColors.green);
    ThemeData theme = Theme.of(context);
    return Container(
        child: ValueListenableBuilder(
      valueListenable: TrackSearchBar.SearchTerm,
      builder: (c, String term, w) {
        List<Track> finalView = term.isEmpty
            ? widget.tracks.sublist(0, 3)
            : widget.tracks
                .where(
                    (e) => e.name.toLowerCase().startsWith(term.toLowerCase()))
                .toList();

        return Column(children: [
          ...finalView.isEmpty
              ? ([
                  Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Center(child: Text('No tracks found for ${term}')))
                ])
              : finalView.map((e) {
                  String artists =
                      e.artists.map((a) => a.name).toList().join(', ');

                  return ListTile(
                      leading: Image(image: NetworkImage(e.albumArt.url)),
                      title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(e.name),
                            Text(artists, style: theme.textTheme.subtitle2),
                            Text(e.durationString(), style: durationStyle)
                          ]));
                }).toList(),
        ]);
      },
    ));
  }
}
