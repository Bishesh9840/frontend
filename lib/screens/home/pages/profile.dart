import 'dart:async';

import 'package:blogapp/screens/home/controllers/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:sensors_plus/sensors_plus.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
    final emailController = TextEditingController();
  final passwordController = TextEditingController();
  dynamic token;
  dynamic role;
  dynamic name;
  dynamic x;
  List<double>? _accelerometerValues;
  final _streamSubscriptions = <StreamSubscription<dynamic>>[];

  final controller = Get.put(ProfileController());
  @override
  void initState() {
    super.initState();
        controller.checkProfile();
    _streamSubscriptions.add(
      accelerometerEvents.listen(
        (AccelerometerEvent event) {
          _accelerometerValues = <double>[event.x, event.y, event.z];
          x = _accelerometerValues?.first;

          if (token != null) {
            if (x < -7) {
              return clearCard();
            } else if (x > 7) {
              return clearCard();
            }
          }
        },
      ),
    );
  }

  void clearCard() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Message'),
              content: const Text('Are you sure you want to logout?'),
              actions: [
                Center(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                            Color.fromARGB(255, 71, 212, 236),
                          ),
                          padding: MaterialStateProperty.all(
                              const EdgeInsets.all(12)),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          ))),
                      child: const Text('Yes'),
                      onPressed: ()  {
                        Navigator.pushNamed(context, '/');

                        const Duration(seconds: 2);
                        MotionToast.warning(
                                description: const Text("Logout Successfull"))
                            .show(context);
                      },
                    ),
                    ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                            Color.fromARGB(255, 71, 212, 236),
                          ),
                          padding: MaterialStateProperty.all(
                              const EdgeInsets.all(12)),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          ))),
                      child: const Text('No'),
                      onPressed: () {
                        Navigator.pushNamed(context, '/');
                      },
                    ),
                  ],
                ))
              ],
            ));
  }

  @override
  void dispose() {
    super.dispose();
    for (final subscription in _streamSubscriptions) {
      subscription.cancel();
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffEEEEFF),
      body: Obx(() => controller.page.value),
    );
  }
}
