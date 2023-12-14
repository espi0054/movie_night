import 'package:flutter/material.dart';
import 'package:movie_night/http_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'movie_screen.dart';


class ShareCodeScreen extends StatefulWidget {
  const ShareCodeScreen({super.key});

  @override
  SSCodeState createState() => SSCodeState();
}

class SSCodeState extends State<ShareCodeScreen> {
  final double baseSpacing = 8.0;
  String code = "";

  @override
  void initState() {
    super.initState();
    startSession();
  }

  Future<void> startSession() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? deviceId = prefs.getString('device_id');
    String? sessionCode = prefs.getString('code');

    if(sessionCode.toString().isEmpty || sessionCode == null)
    {
      String url = "https://movie-night-api.onrender.com/start-session?device_id=${deviceId.toString()}";
      await HttpHelper.get(url);
      if(HttpHelper.success())
      {
        setState(() {
          code = HttpHelper.getCode();
        });
        prefs.setString('session_id', HttpHelper.getSessionId());
        prefs.setString('code', code);
      }
    }
    else
    {
      setState(() {
        code = sessionCode.toString();
      });
    }
    
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('Movie Night', style: textTheme.displayMedium,),
        elevation: 0,
        backgroundColor: Colors.blue.shade500,
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: EdgeInsets.fromLTRB(baseSpacing * 6, 0, baseSpacing * 6, 0),
              child: Text(code, style: textTheme.displayLarge),
            ),
            Container(
              margin: EdgeInsets.all(baseSpacing * 9),
              child: Text('Share code with your friend', style: textTheme.headlineLarge),
            ),
            ElevatedButton.icon(
              icon: const Icon(Icons.start),
              label: Text('Begin', style: textTheme.bodyLarge,),
              onPressed: () {
                              Navigator.push(context,
                              MaterialPageRoute(builder: (context) => const MovieScreen()),);
                            }
            ),
          ],
        ),
      ),
    );
  }

}
