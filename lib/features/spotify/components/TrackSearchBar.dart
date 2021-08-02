import 'package:flutter/material.dart';

class TrackSearchBar extends StatelessWidget {
  static ValueNotifier<String> SearchTerm = ValueNotifier("");
  const TrackSearchBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.fromLTRB(0, 0, 0, 6),
        child: Container(
            padding: EdgeInsets.symmetric(vertical: 2, horizontal: 2),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: Colors.grey[600],
            ),
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.all(8),
                  child: Icon(Icons.search),
                ),
                Expanded(
                  child: TextField(
                    onChanged: (v) => SearchTerm.value = v,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Find tracks in playlist",
                        hintStyle: TextStyle(color: Colors.white)),
                  ),
                )
              ],
            )));
  }
}
