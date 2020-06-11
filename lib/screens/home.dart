import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:fluttertube/bloc/favorite_bloc.dart';
import 'package:fluttertube/bloc/videos_bloc.dart';
import 'package:fluttertube/delegates/data_search.dart';
import 'package:fluttertube/models/video.dart';
import 'package:fluttertube/screens/favorites_screen.dart';
import 'package:fluttertube/widgets/video_tile.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final blocVideos = BlocProvider.of<VideosBloc>(context);
    final blocFav = BlocProvider.of<FavoriteBloc>(context);

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 3, 3, 3),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.black87,
        title: Container(height: 25, child: Image.asset("images/yt_logo.png")),
        actions: <Widget>[
          Align(
            alignment: Alignment.center,
            child: StreamBuilder<Map<String, Video>>(
              stream: blocFav.outFav,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Text(
                    "${snapshot.data.length}",
                    style: TextStyle(fontSize: 18),
                  );
                } else {
                  return Container();
                }
              },
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.star,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => Favorites()));
            },
          ),
          IconButton(
            icon: Icon(
              Icons.search,
              color: Colors.white,
            ),
            onPressed: () async {
              String result =
                  await showSearch(context: context, delegate: DataSearch());
              if (result != null) {
                blocVideos.inSearch.add(result);
              }
            },
          )
        ],
      ),
      body: StreamBuilder(
        stream: blocVideos.outVideos,
        initialData: [],
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemBuilder: (context, index) {
                if (index < snapshot.data.length) {
                  return VideoTile(snapshot.data[index]);
                } else if (index > 1) {
                  blocVideos.inSearch.add(null);
                  return Container(
                    alignment: Alignment.center,
                    height: 40,
                    width: 40,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                    ),
                  );
                } else {
                  return Container(
                      height: MediaQuery.of(context).size.height,
                      alignment: Alignment.center,
                      child: Text(
                        "Nenhum vídeo pesquisado",
                        style: TextStyle(color: Colors.white),
                      ));
                }
              },
              itemCount: snapshot.data.length + 1,
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
