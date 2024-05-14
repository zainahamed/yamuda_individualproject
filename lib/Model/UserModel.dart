class UserModel {
  final String uid;

  String username;
  String email;
  String contact;
  String company;
  String occupation;
  int totalRides;
  int totalPassengers;
  String? imageUrl;
  String? linkedin;

  UserModel(
      this.email,
      this.contact,
      this.totalRides,
      this.totalPassengers,
      this.uid,
      this.username,
      this.company,
      this.occupation,
      this.imageUrl,
      this.linkedin);
}
