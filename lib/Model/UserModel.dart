class UserModel {
  final String uid;

  final String username;
  final String email;
  final int contact;
  final int totalRides;
  final int totalPassengers;

  UserModel(this.email, this.contact, this.totalRides, this.totalPassengers,
      {required this.uid, required this.username});
}
