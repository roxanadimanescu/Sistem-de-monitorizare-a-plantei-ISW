import 'dart:convert';

import 'package:plant_monitoring_system/myPlants.dart';
import 'package:test/test.dart';
import 'package:http/http.dart' as http;

void main() {
  group('Get_Post', () {
    test('value should return user id', () async {
      final String apiLoginURL =
          'https://plantmonitoringsystem5.000webhostapp.com/login.php';
      var dataLogin = {'username': 'Elena', 'password': 'pass'};
      var userIdResponse= await http.post(Uri.parse(apiLoginURL), body: json.encode(dataLogin));
      print(userIdResponse.body);
      var json1 = jsonDecode(userIdResponse.body);
      var idJson = json1['id'];
      var idForUser = idJson.toString();
      expect(idForUser, "4" );
    });

    test('value should return list of plants ', () async {
      final String getPlantURL =
          'https://plantmonitoringsystem5.000webhostapp.com/getMyPlant.php';
      var data = {'id': '1'};
      var getPlantResponse = await http.post(Uri.parse(getPlantURL), body: json.encode(data));
      print(getPlantResponse.body);
      final items =
      json.decode(getPlantResponse.body).cast<Map<String, dynamic>>();
      List<Plantdata> plantList = items.map<Plantdata>((json) {
        return Plantdata.fromJson(json);
      }).toList();
      var myPlantJson = jsonDecode(getPlantResponse.body);
      var expected_list=[{"id":"2","user_id":"1","plant_id":"2","name":"","type":"Orchid","dimension":"2","description":"Orchid plants are one of the largest plant species in the world with over 20,000 different varieties. A Phalaenopsis Orchid plant lives for quite some time, and with proper care, blooms again and again for many years. The flowers of an orchid plant may be yellow, white, pink, lavender, spotted, or striped. These plants are a beautiful, inexpensive replacement for a cut flower arrangement or just an added delight for any room in your home or office","min_humidity":"40","max_humidity":"60","min_temp":"18","max_temp":"26","min_light":"300","max_light":"800"},{"id":"5","user_id":"1","plant_id":"5","name":"mada","type":"Madagascar Jasmine","dimension":"2","description":"Garden jasmine, but also room jasmine is a plant that has many health benefits. Called the \"Gift of God,\" jasmine is an aphrodisiac plant with effects known from ancient times.\r\n\r\nJasmine is a shrub with white and fragrant flowers and has been known since antiquity as yasmin - meaning \"God's gift\" - when its aphrodisiac effects, but also the health benefits of the skin were highly valued.","min_humidity":"30","max_humidity":"50","min_temp":"18","max_temp":"22","min_light":"600","max_light":"800"},{"id":"3","user_id":"1","plant_id":"3","name":"","type":"Begonia","dimension":"2","description":"A Begonia plant, part of the Begoniaceae  family, is often considered to be an outdoor plant, but they also make excellent indoor plants that can bloom the entire year. Begonia plants originally came from the tropical, moist regions of southern Asia, Africa, South America, and Central America which is why they require such high humidity to grow well.","min_humidity":"50","max_humidity":"75","min_temp":"18","max_temp":"24","min_light":"500","max_light":"800"},{"id":"3","user_id":"1","plant_id":"3","name":"cactusel","type":"Begonia","dimension":"2","description":"A Begonia plant, part of the Begoniaceae  family, is often considered to be an outdoor plant, but they also make excellent indoor plants that can bloom the entire year. Begonia plants originally came from the tropical, moist regions of southern Asia, Africa, South America, and Central America which is why they require such high humidity to grow well.","min_humidity":"50","max_humidity":"75","min_temp":"18","max_temp":"24","min_light":"500","max_light":"800"},{"id":"4","user_id":"1","plant_id":"4","name":"","type":"Bamboo","dimension":"2","description":"A Lucky Bamboo plant is really made up of the cut stalks of a Dracaena Sanderiana and is native to West Africa and Eastern Asia. The Lucky Bamboo plant stalks are usually 4\u2033- 24\u2033in height. Followers of Feng Shui believe that the Lucky Bamboo plant brings prosperity and good fortune to a home or business.","min_humidity":"80","max_humidity":"100","min_temp":"21","max_temp":"29","min_light":"200","max_light":"600"},{"id":"1","user_id":"1","plant_id":"1","name":"cactusel","type":"Cactus","dimension":"2","description":"A cactus plant is an excellent, easy care, indoor or outdoor plant that adapted to very hot, dry, desert areas. Most cacti are Succulent Plants which means they store water so they can withstand long periods of drought. The leaves of a cactus plant became spines, so it is only the thick, fleshy, stems of the plant store the water.","min_humidity":"10","max_humidity":"30","min_temp":"15","max_temp":"26","min_light":"500","max_light":"800"}];
       expect(myPlantJson, expected_list );
    });

    test('value should return new username', () async {
      final String apiChangeUsernameURL = 'https://plantmonitoringsystem5.000webhostapp.com/changeUsername.php';
      var data = {'id': '1', 'new_username':'Dani'};
     var userChangedResponse= await http.post(Uri.parse(apiChangeUsernameURL), body: json.encode(data));
      print(userChangedResponse.body);
      var json1 = jsonDecode(userChangedResponse.body);
      var usernameJson = json1[0]["username"];
      var usernameForUser = usernameJson.toString();
      expect(usernameForUser, "Dani" );
    });
  });
}
