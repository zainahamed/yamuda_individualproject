import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:yamudacarpooling/Model/Direction_details_info.dart';

final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

User currentuser = FirebaseAuth.instance.currentUser!;

StreamSubscription<Position>? streamSubscriptionPosition;
StreamSubscription<Position>? streamSubscriptionPassengerLivePosition;
late StreamSubscription<QuerySnapshot> driverResponse;

String userDropoffAddress = '';
int totalSeats = 1;
DirectionDetailsInfo? tripDirectionDetailsInfo;

int currentpassengers = 0;
