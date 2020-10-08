import 'dice.dart';
import 'knockout.dart';

import 'package:flutter/material.dart';
import 'package:flare_flutter/flare_actor.dart';

class Single extends StatefulWidget {
  @override
  _SingleState createState() => _SingleState();
}

class _SingleState extends State<Single> {
  String currentAnimation;

  @override
  void initState() {
    currentAnimation = 'Start';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text('Single Dice'),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.fitness_center),
              onPressed: () {
                MaterialPageRoute route =
                    MaterialPageRoute(builder: (context) => KnockOutScreen());
                Navigator.push(context, route);
              })
        ],
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Container(
              height: height / 1.7,
              width: width * 0.8,
              child: FlareActor(
                "assets/dice.flr",
                fit: BoxFit.contain,
                animation: currentAnimation,
              ),
            ),
            SizedBox(
                width: width / 2.5,
                height: height / 10,
                child: RaisedButton(
                  child: Text('Play'),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24)),
                  onPressed: () {
                    setState(() {
                      currentAnimation = 'Roll';
                    });
                    Dice.wait3seconds().then((_) {
                      callResult();
                    });
                  },
                ))
          ],
        ),
      ),
    );
  }

  void callResult() async {
    Map<int, String> animation = Dice.getRandomAnimation();
    setState(() {
      currentAnimation = animation.values.first;
    });
  }
}
