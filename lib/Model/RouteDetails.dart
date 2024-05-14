class RouteDetails {
  String? driverId;
  String? pickupLocation;
  double? pickupLoactionlatitude;
  double? pickupLoactionlongitude;
  String? dropOffLocation;
  String? vehicleModel;
  int? seats;
  String? passengerId;
  String? name;
  String? company;

  RouteDetails({
    this.driverId,
    this.pickupLocation,
    this.dropOffLocation,
    this.vehicleModel,
    this.seats,
    this.pickupLoactionlatitude,
    this.pickupLoactionlongitude,
    this.passengerId,
    this.company,
    this.name,
  });
}
