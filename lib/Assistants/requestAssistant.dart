import 'dart:convert';

import 'package:http/http.dart' as http;

class RequestAssistant
{
  static Future<dynamic> getRequest(String url) async
  {
    var Url = Uri.parse(url);
    http.Response response = await http.get(Url);
    
    try {
      if (response.statusCode == 200) {
        String jSonData = response.body;
        var decodeData = jsonDecode(jSonData);
        return decodeData;
      }
      else {
        return "Echec, pas de reponse.";
      }
    }
    catch(exp)
    {
      return "Echec, pas de reponse.";
    }
    
  }
}