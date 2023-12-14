import 'package:flutter/material.dart';
import 'package:movie_night/http_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'movie_screen.dart';

class EnterCodeScreen extends StatefulWidget {
  const EnterCodeScreen({super.key});

  @override
  EnterCodeState createState() => EnterCodeState();
}

class EnterCodeState extends State<EnterCodeScreen> {
  final double baseSpacing = 8.0;
  final TextEditingController _codeController = TextEditingController();
  String? _errorMsg;

  @override
  void initState() {
    super.initState();
  }

  Future<void> joinSession() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? deviceId = prefs.getString('device_id');
    String? sessionCode = _codeController.text;

    String url = "https://movie-night-api.onrender.com/join-session?device_id=";
    url += "$deviceId&code=$sessionCode";
    await HttpHelper.get(url);

    if(HttpHelper.success())
    {
      setState(() {
        prefs.setString('session_id', HttpHelper.getSessionId());
      });
      prefs.setString('code', sessionCode);

      if(!mounted){
        return;
      }
      Navigator.push(context, MaterialPageRoute(builder: (context) => const MovieScreen()));
    }
    else
    {
      setState(() {
        _errorMsg = "Invalid Code. Please try again.";
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
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: TextFormField(
              controller: _codeController,
              maxLength: 4,
              keyboardType: TextInputType.number,
              style: textTheme.displaySmall,
              decoration: const InputDecoration(
                labelText: 'Enter the code from your friend.',
                ),
              ),
            ),
            ElevatedButton.icon(
              icon: const Icon(Icons.start),
              label: Text('Begin', style: textTheme.bodyLarge,),
              onPressed: joinSession,
            ),
            if (_errorMsg != null)
              AlertDialog(
                title: const Text('Error',),
                content: Text(_errorMsg!),
                actions: <Widget>[
                  TextButton(
                    child: const Text('OK'),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

}
