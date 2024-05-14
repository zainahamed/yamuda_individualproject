
import "dart:convert";

import "package:http/http.dart" as http;

class RequestAssistance {

  static  Future<dynamic> receiveRequest(String url) async {

    http.Response httpResponse = await http.get(Uri.parse(url));

    try{

      if(httpResponse.statusCode==200){
        String responsedata=httpResponse.body;
        var decodeResponseData = jsonDecode(responsedata);
        return decodeResponseData;

      }
      else{
        return 'error occurred, no response';
      }
    }catch(e){
        return 'error occurred, no response';

    }
  }
}