import 'package:flutter/material.dart';
import 'package:flutter_spotify_africa_assessment/colors.dart';
import 'package:flutter_spotify_africa_assessment/features/spotify/api/Category.dart';
import 'package:flutter_spotify_africa_assessment/routes.dart';

import 'package:flutter_spotify_africa_assessment/features/spotify/api/client.dart';
import 'package:flutter_spotify_africa_assessment/features/spotify/components/PlaylistGrid.dart';

// TODO: fetch and populate playlist info and allow for click-through to detail
// Feel free to change this to a stateful widget if necessary
class SpotifyCategory extends StatelessWidget {
  final String categoryId;

  const SpotifyCategory({
    Key? key,
    required this.categoryId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future<Category> category = SpotifyApiClient.getCategory(this.categoryId);
    ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("{CategoryName}"),
        actions: [
          IconButton(
            icon: Icon(Icons.info),
            onPressed: () => Navigator.of(context).pushNamed(AppRoutes.about),
          ),
        ],
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: <Color>[
                AppColors.blue,
                AppColors.cyan,
                AppColors.green,
              ],
            ),
          ),
        ),
      ),
      body: Container(
          padding: const EdgeInsets.all(16),
          child: FutureBuilder(
            future: category,
            builder: (c, snap) {
              if (snap.hasError) return Text(snap.error.toString());
              if (!snap.hasData)
                return Center(child: CircularProgressIndicator());
              Category c = snap.data as Category;

              return SingleChildScrollView(
                child: Column(
                  children: [
                    Center(
                        child: Column(
                      children: [
                        Text(
                          c.name,
                          style: theme.textTheme.headline3,
                        ),
                        Padding(
                          padding: EdgeInsets.all(12),
                          child: Image(
                              fit: BoxFit.fill,
                              image: NetworkImage(c.icons.first.url)),
                        ),
                      ],
                    )),
                    PlaylistGrid(categoryId: this.categoryId)
                  ],
                ),
              );
            },
          )),
    );
  }
}
