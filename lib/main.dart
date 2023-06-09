import 'package:fluentui_icons/fluentui_icons.dart';
import 'package:flutter/material.dart';
import '../Styles.dart';
import 'package:sudoku2/widgets/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  static final List<Widget> listOfPages = <Widget>[
    HomePage(),
    Text("Statistics page")
  ];

  int selectedIndex = 0;

  void onBottomNavigationTapHandler(int index){
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Sudoku 2.0",
      home: Scaffold(
        appBar: AppBar(
          actions: [
            Container(
              margin: const EdgeInsets.only(right: 10),
              child: IconButton(
                icon: Icon(Icons.settings),
                color: Colors.white,
                onPressed: (){
                  print("Settings activated");
                },
              ),
            )
          ],
          backgroundColor: Styles.themeColor,
          title: Text("SuDoKu"),
          centerTitle: true,
        ),
        body: listOfPages[selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          selectedItemColor: Colors.blueGrey,
          unselectedItemColor: Colors.black,
          currentIndex: selectedIndex,
          onTap: onBottomNavigationTapHandler,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(FluentSystemIcons.ic_fluent_home_regular),
                activeIcon: Icon(FluentSystemIcons.ic_fluent_home_filled),
                label: "Home"),
            BottomNavigationBarItem(
                icon: Icon(FluentSystemIcons.ic_fluent_book_formula_statistics_regular),
                activeIcon: Icon(FluentSystemIcons.ic_fluent_book_formula_statistics_filled),
                label: "Statistics")
          ],
        ),
      )
    );
  }
}
