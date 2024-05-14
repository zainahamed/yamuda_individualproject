import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yamudacarpooling/Colors/Colors.dart';
import 'package:yamudacarpooling/Services/VehicleService.dart';
import 'package:yamudacarpooling/Widgets/SnackbarMessage.dart';
import 'package:yamudacarpooling/infoHandler/App_info.dart';

class VehicleView extends StatefulWidget {
  final String id;
  final String model;
  final String seats;
  final String imageUrl;
  const VehicleView(
      {super.key,
      required this.model,
      required this.seats,
      required this.imageUrl,
      required this.id});

  @override
  State<VehicleView> createState() => _VehicleViewState();
}

class _VehicleViewState extends State<VehicleView> {
  VehicleService vehicleService = VehicleService();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        showDialog(
            context: context,
            builder: (BuildContext context) => AlertDialog(
                  backgroundColor: Secondary,
                  title: const Text(
                    "Do you want to Delete this Vehicle",
                  ),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text("No")),
                    TextButton(
                        onPressed: () async {
                          await vehicleService.deleteVehicle(widget.id);
                          Navigator.of(context).pop();

                          SnackBarMessage.showSnackBarSuccess(
                              context, "Vehicle Deleted!");
                        },
                        child: const Text("Yes"))
                  ],
                  elevation: 21,
                ));
      },
      onTap: () async {
        print(widget.id);
        Provider.of<AppInfo>(context, listen: false).setDirverSelectedVehicle(
            await vehicleService.getVehicle(widget.id));

        SnackBarMessage.showSnackBarSuccess(
            context, 'Your Default Vehicle has been changed');
      },
      child: Container(
        margin: const EdgeInsets.all(10),
        height: 110,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(width: 1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 25),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.model,
                    style: const TextStyle(
                        color: Primary,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                    maxLines: 1,
                  ),
                  Text("Seat :" + widget.seats + " Capacity",
                      style: TextStyle(
                          color: Primary,
                          fontSize: 20,
                          fontWeight: FontWeight.w400)),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: widget.imageUrl == ''
                    ? Image.network(
                        "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png",
                      )
                    : Image.network(
                        widget.imageUrl!,
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
