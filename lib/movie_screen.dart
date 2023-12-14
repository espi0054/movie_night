import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'http_helper.dart';

class MovieScreen extends StatefulWidget {
  const MovieScreen({super.key});

  @override
  MovieScreenState createState() => MovieScreenState();
}

class MovieScreenState extends State<MovieScreen> {
  List<Map<String, dynamic>> movies = [];
  int currentPage = 1;
  int currentIndex = 0;
  final double baseSpacing = 8.0;
  late dynamic textTheme;
  bool showIcon = false;
  bool rightSwipe = false;

  @override
  void initState() {
    super.initState();
    fetchMovies();
  }

  Future<void> fetchMovies() async {
    // Implement TMDB API call here and update the `movies` list
    String url =
        "https://api.themoviedb.org/3/discover/movie?include_adult=false&include_video=false";
    url +=
        "&language=en-US&page=$currentPage&sort_by=popularity.desc&api_key=d8448705a740965b66eafee6799f485e";
    await HttpHelper.get(url);
    if (HttpHelper.success()) {
      setState(() {
        movies = HttpHelper.getMovies();
      });
    }
  }

  Future<void> voteMovie(bool vote, int movieId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? sessionId = prefs.getString('session_id');
    String url =
        "https://movie-night-api.onrender.com/vote-movie?session_id=${sessionId.toString()}";
    url += "&movie_id=$movieId&vote=$vote";

    await HttpHelper.get(url);
    if (HttpHelper.success()) {
      if (HttpHelper.isMatchedMovie()) {
        showMatchDialog(movies[currentIndex]);
      }
    }

    if (currentIndex == 19) {
      currentPage += 1;
      await fetchMovies();
      setState(() {
        currentIndex = 0;
      });
    } else {
      setState(() {
        currentIndex += 1;
      });
    }

    setState(() {
      showIcon = false;
    });
  }

  void showMatchDialog(Map<String, dynamic> matchedMovie) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("${matchedMovie['title']} Winner!",
              style: textTheme.displaySmall),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Image.network(
                    "https://image.tmdb.org/t/p/w500${matchedMovie['poster_path']}"),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'OK',
                style: textTheme.displaySmall,
                textAlign: TextAlign.center,
              ),
              onPressed: () {
                Navigator.popUntil(context, ModalRoute.withName('/'));
              },
            ),
          ],
        );
      },
    );
  }

  Widget renderIcon() {
    if (!showIcon) {
      return const Text(" ");
    } else {
      if (rightSwipe) {
        return const Center(
          child: Icon(
            Icons.thumb_up,
            color: Colors.black,
            size: 100.0,
          ),
        );
      } else {
        return const Center(
          child: Icon(
            Icons.thumb_down,
            color: Colors.black,
            size: 100.0,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Movie Screen')),
      body: Align(
        alignment: Alignment.center,
        heightFactor: 2,
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          height: MediaQuery.of(context).size.height * 0.8,
          child: (movies.isNotEmpty && !showIcon)
              ? buildMovieCard(movies[currentIndex])
              : renderIcon(),
        ),
      ),
    );
  }

  Widget buildMovieCard(Map<String, dynamic> movie) {
    return Dismissible(
      key: UniqueKey(),
      onDismissed: (direction) async {
        if (direction == DismissDirection.endToStart) {
          setState(() {
            rightSwipe = false;
            showIcon = true;
          });
          await voteMovie(false, movie['id']);
        } else {
          setState(() {
            rightSwipe = true;
            showIcon = true;
          });
          await voteMovie(true, movie['id']);
        }
      },
      child: Card(
          elevation: 4.0,
          child: Container(
            color: Colors.white,
            padding: EdgeInsets.all(baseSpacing * 3),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Image.network(
                  "https://image.tmdb.org/t/p/w500${movies[currentIndex]['poster_path']}",
                  height: 360,
                  fit: BoxFit.cover,
                  loadingBuilder: (BuildContext context, Widget child,
                      ImageChunkEvent? loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    );
                  },
                ),
                ListTile(
                  title: Text(
                    movie['title'],
                    textAlign: TextAlign.center,
                    style: textTheme.displaySmall,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      movie['release_date'],
                      style: textTheme.headlineLarge,
                    ),
                    Container(
                      width: 50,
                      height: 50,
                      margin: EdgeInsets.fromLTRB(baseSpacing * 10, 0, 0, 0),
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle, color: Colors.blue),
                      child: Text(
                        movie['vote_average'].toString(),
                        style: textTheme.displayMedium,
                      ),
                    )
                  ],
                )
              ],
            ),
          )),
    );
  }
}
