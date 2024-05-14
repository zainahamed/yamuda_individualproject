import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yamudacarpooling/Model/Message%20.dart';

class TrainRoute {
  String _routeId = "null";
  String _routeName = "null";
  String _userId = "";
  List<Message> _chatList = [];
  List<String> _trainList = [];

  TrainRoute(this._routeId, this._routeName, this._userId, this._chatList,
      this._trainList);

  String get routeId => _routeId;
  set routeId(String value) => _routeId = value;

  String get routeName => _routeName;
  set routeName(String value) => _routeName = value;
  String get userId => _userId;
  set userId(String value) => _userId = value;

  List<Message> get chatList => _chatList;
  set chatList(List<Message> value) => _chatList = value;

  List<String> get trainList => _trainList;
  set trainList(List<String> value) => _trainList = value;

  static CollectionReference routesCollection =
      FirebaseFirestore.instance.collection('routes');

  static Future<void> addTrainRoute(TrainRoute route) async {
    await routesCollection.add({
      'routeId': route.routeId,
      'routeName': route.routeName,
      "userId": route.userId,
      'chatList': route.chatList.map((message) => message.toMap()).toList(),
      'trainList': route.trainList,
    });
  }

  static Future<List<TrainRoute>> getTrainRoutes() async {
    QuerySnapshot snapshot = await routesCollection.get();
    return snapshot.docs
        .map((doc) => TrainRoute(
              doc.id,
              doc['routeName'],
              doc['userId'],
              (doc['chatList'] as List<dynamic>)
                  .map((message) => Message.fromMap(message))
                  .toList(),
              List<String>.from(doc['trainList']),
            ))
        .toList();
  }
}
