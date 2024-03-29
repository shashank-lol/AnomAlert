import 'dart:convert';

import 'package:anom_alert/providers/api_key.dart';
import 'package:anom_alert/providers/camera_provider.dart';
import 'package:anom_alert/screens/camera_detail.dart';
import 'package:anom_alert/screens/home_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:anom_alert/models/camera.dart';

class NewCamera extends StatelessWidget {
  const NewCamera(this.camera, {required this.token, super.key});

  final Camera camera;
  final String token;

  @override
  Widget build(BuildContext context) {
    void onPressCamera() async {
      final reply = await Navigator.of(context).push<String>(MaterialPageRoute(
          builder: (ctx) => CameraDetailsScreen(
                camera,
                token: token,
              )));
      if (reply == "delete") {
        print("delete");
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (ctx) => HomePage(
                  token: token,
                )));
      } else {
        print("start");
        final notificationToken = await FirebaseMessaging.instance.getToken(
            vapidKey:
                api_key);
        print(notificationToken);
        Future.delayed(Duration(seconds: 5), () {
          final response = http.post(Uri.parse("$baseUrl/user/start"),
              headers: {
                'Content-type': 'application/json',
                'Accept': 'application/json',
                'Authorization': 'Bearer $token'
              },
              body: jsonEncode(<String, String>{
                'camera_id': camera.id!,
                'device_token': notificationToken!
              }));
        });
      }
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: InkWell(
        onTap: () {
          onPressCamera();
        },
        splashColor: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          height: 160,
          width: double.infinity,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                colors: [Color(0xFF282828), Color(0xFF282828).withOpacity(0.9)],
              )),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      camera.name,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(color: Colors.white),
                    ),
                    camera.isTurnedOn
                        ? Text("Current Status : ON")
                        : Text("Current Status : OFF"),
                    Spacer(),
                    // Text(
                    //   "Anomaly detected",
                    //   style: Theme.of(context)
                    //       .textTheme
                    //       .bodyMedium!
                    //       .copyWith(color: Colors.yellow),
                    // ),
                  ],
                ),
                const Spacer(),
                Image.asset(
                  "assets/images/cctv-camera.png",
                  height: 100,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
