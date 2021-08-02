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
    TextStyle titleStyle = TextStyle(fontSize: 14);
    TextStyle artistStyle = TextStyle(fontSize: 12);
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

        return Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Column(children: [
              ...finalView.isEmpty
                  ? ([
                      Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Center(
                              child: Text('No tracks found for ${term}')))
                    ])
                  : finalView.map((e) {
                      String artists =
                          e.artists.map((a) => a.name).toList().join(', ');

                      return Container(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          children: [
                            Image(
                                width: 64,
                                height: 64,
                                image: NetworkImage(e.albumArt.url)),
                            Container(
                                padding: EdgeInsets.fromLTRB(16, 0, 0, 0),
                                height: 64,
                                child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(e.name, style: titleStyle),
                                      Text(
                                        artists,
                                        style: artistStyle,
                                        overflow: TextOverflow.clip,
                                      ),
                                      Text(e.durationString(),
                                          style: durationStyle)
                                    ]))
                          ],
                        ),
                      );
                    }).toList(),
            ]));
      },
    ));
  }
}
