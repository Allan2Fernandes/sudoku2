import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sudoku2/Styles.dart';
import 'package:sudoku2/widgets/game_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.grey[300],
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 50,
                  width: 150,
                  margin: EdgeInsets.only(bottom: 30),
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(50)),
                      color: Styles.buttonsColor
                  ),
                  child: TextButton(
                    onPressed: () { 
                      Navigator.push(
                        context, 
                        MaterialPageRoute(builder: (context)=> const GamePage())
                      );
                    },
                    child: Text("New Game", style: TextStyle(color: Colors.white),),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 30),
                  height: 50,
                  width: 150,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(50)),
                    color: Styles.buttonsColor,
                  ),
                  child: TextButton(
                    onPressed: (){},
                    child: Text("Continue a game", style: TextStyle(color: Colors.white),),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
