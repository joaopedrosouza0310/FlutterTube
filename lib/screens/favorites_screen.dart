import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter_youtube/flutter_youtube.dart';
import 'package:fluttertube/bloc/favorite_bloc.dart';
import 'package:fluttertube/models/video.dart';
import 'package:fluttertube/api.dart';

class Favorites extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<FavoriteBloc>(context);
    final bgColor = Color.fromARGB(255, 3, 3, 3);

    return Scaffold(
      appBar: AppBar(
        title: Text("Favoritos"),
        centerTitle: true,
        backgroundColor: bgColor,
      ),
      backgroundColor: bgColor,
      body: StreamBuilder<Map<String, Video>>(
        stream: bloc.outFav,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView(
              children: snapshot.data.values.map((video) {
                return InkWell(
                    onTap: () {
                      FlutterYoutube.playYoutubeVideoById(
                          fullScreen: true,
                          autoPlay: true,
                          backgroundColor: bgColor,
                          apiKey: API_KEY,
                          videoId: video.id);
                    },
                    onLongPress: () {
                      bloc.toggleFavorite(video);
                    },
                    child: Row(
                      children: <Widget>[
                        Container(
                          width: 100,
                          height: 50,
                          child: Image.network(video.thumb),
                        ),
                        Expanded(
                          child: Text(
                            video.title,
                            style: TextStyle(color: Colors.white),
                            maxLines: 2,
                          ),
                        )
                      ],
                    ));
              }).toList(),
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
