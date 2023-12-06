import 'package:flutter/material.dart';
import 'package:tokobukusederhana/screens/LoginPage.dart';


class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
   
    Future.delayed(Duration(seconds: 3), () {
      
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    });

    return Scaffold(
      backgroundColor: Colors.white, 
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'assets/images/home.jpg', 
              height: 300, 
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Text(
                'Toko Buku Sederhana',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
