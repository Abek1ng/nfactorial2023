// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flappy_bird/bird.dart';
import 'package:flutter/material.dart';
import 'home_page.dart';

class MenuPage extends StatefulWidget {
  final int currentScore;
  final int maxScore;

  const MenuPage({required this.currentScore, required this.maxScore});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("images/sprites/background-day.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.1,
              ),
              GestureDetector(
                onTap: () {
                  birdColor = "yellow";
                  setBirdPath('images/sprites/yellowbird-midflap.png');
                },
                child: Image.asset(
                  'images/sprites/yellowbird-midflap.png',
                  scale: 0.75,
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              GestureDetector(
                onTap: () {
                  birdColor = "blue";
                  setBirdPath('images/sprites/bluebird-midflap.png');
                },
                child: Image.asset(
                  'images/sprites/bluebird-midflap.png',
                  scale: 0.75,
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              GestureDetector(
                onTap: () {
                  birdColor = "red";
                  setBirdPath('images/sprites/redbird-midflap.png');
                },
                child: Image.asset(
                  'images/sprites/redbird-midflap.png',
                  scale: 0.75,
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.1,
              ),
              Image.asset(
                birdPath,
                scale: 0.75,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.15,
              ),
              Text(
                'Current Score: ${widget.currentScore}',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      blurRadius: 4,
                      color: Colors.black,
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
              ),
              Text(
                'Max Score: ${widget.maxScore}',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      blurRadius: 4,
                      color: Colors.black,
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.1,
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    
                  });
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage()),
                  );
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      Color.fromARGB(255, 236, 185, 103)),
                  padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                    EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                ),
                child: Text(
                  "Restart",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(
                height: 16,
              ),
              
            ],
          ),
        ),
      ),
    );
  }
}
