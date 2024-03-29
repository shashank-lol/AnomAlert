import 'package:anom_alert/screens/auth/login.dart';
import 'package:anom_alert/screens/login_or_register.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:anom_alert/screens/home_page.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: LoginOrRegisterScreen(),
      // body: StreamBuilder<User?>(stream: FirebaseAuth.instance.authStateChanges(),
      // builder: (context, snapshot){
      //   if(snapshot.hasData) {
      //     return const HomePage();
      //   }
      //   else{
      //     return const LoginOrRegisterScreen();
      //   }
      // },),
    );
  }
}
