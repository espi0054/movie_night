import 'package:http/http.dart' as http;
import 'dart:convert';

class HttpHelper {
  static http.Response? resp;

  // Method for GET request
  static Future<void> get(String url) async {
    final response = await http.get(Uri.parse(url));
    resp = response;
  }

  static bool success(){
    final response = jsonDecode(resp!.body) as Map<String, dynamic>;
    if(response['results'] != null){
      return true;
    }
    else
    {
      return resp?.statusCode == 200;
    }
    
  }

  static String getSessionId(){ 
    final response = jsonDecode(resp!.body) as Map<String, dynamic>;
    return response['data']['session_id'];
  }

  static String getCode(){
    final response = jsonDecode(resp!.body) as Map<String, dynamic>;
    return response['data']['code'];
  }

  static bool isMatchedMovie(){
    final response = jsonDecode(resp!.body) as Map<String, dynamic>;
    return response['data']['match'];
  }

  static List<Map<String, dynamic>> getMovies(){
    final response = jsonDecode(resp!.body) as Map<String, dynamic>;
    List<dynamic> tResult = response['results'];
    List<Map<String, dynamic>> map = [];
    for(int cnt=0; cnt < 20; cnt++){
      Map<String, dynamic> movie = tResult[cnt];
      map.add(movie);
    }
    
    return map;
  }

}
