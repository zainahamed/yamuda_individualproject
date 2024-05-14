import 'package:yamudacarpooling/Model/ActiveNearlyAvailableUser.dart';

class GeofireAsistant {
  static List<ActiveNearbyAvailableUser> activeNearbyAvailableUserList = [];

  static List<String> onlineRidesDriverStartLocationList = [];

  /* static void deleteofflineUserfromList(String id) {
    int indexNumber =
        activeNearbyAvailableUserList.indexWhere((element) => element.id == id);
    activeNearbyAvailableUserList.removeAt(indexNumber);
  }

  static void updateActiveNearByAvailableUser(
      ActiveNearbyAvailableUser activeNearbyAvailableUser) {
    int indexNumber = activeNearbyAvailableUserList
        .indexWhere((element) => element.id == activeNearbyAvailableUser.id);
    activeNearbyAvailableUserList[indexNumber].locationlatitude =
        activeNearbyAvailableUser.locationlatitude;
    activeNearbyAvailableUserList[indexNumber].locationlongitude =
        activeNearbyAvailableUser.locationlongitude;
  }

  static void deleteonlineRidesDriverStartLocationList(String id) {
    int indexNumber = onlineRidesDriverStartLocationList
        .indexWhere((element) => element == id);
    onlineRidesDriverStartLocationList.removeAt(indexNumber);
  }

  static void updateonlineRidesDriverStartLocationList(String id) {
    int indexNumber = onlineRidesDriverStartLocationList
        .indexWhere((element) => element == id);
  } */
}
