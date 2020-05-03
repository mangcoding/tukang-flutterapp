
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:call_tukang/constants/constants.dart';

class GridDashboard extends StatelessWidget {
  static BuildContext _context;

  Items item1 = new Items(
    title: "Order",
    img: "assets/calendar.png",
    callAction: (){
      Navigator.of(_context).pushNamed(ORDER);
    },
  );

  Items item2 = new Items(
    title: "Categories",
    img: "assets/food.png",
    callAction: (){
      Navigator.of(_context).pushNamed(ORDER);
    },
  );

  Items item3 = new Items(
    title: "Tracking",
    img: "assets/map.png",
    callAction: (){
      Navigator.of(_context).pushNamed(HOME);
    },
  );

  Items item4 = new Items(
    title: "Tentang Kami",
    img: "assets/festival.png",
    callAction: (){
      print("Activity clicked");
    },
  );

  Items item5 = new Items(
    title: "To do",
    img: "assets/todo.png",
    callAction: (){
      print("Todo clicked");
    },
  );

  Items item6 = new Items(
    title: "Settings",
    img: "assets/setting.png",
    callAction: (){
      print("Settings clicked");
    },
  );

  @override
  Widget build(BuildContext context) {
    _context = context;
    final List<Items> myList = [item1, item2, item3, item4, item5, item6];
    Color fontColor = Colors.white;
    Color bgColor = Color(0xff01A0C7);
    return Flexible(
      child: GridView.count(
          childAspectRatio: 1.0,
          padding: EdgeInsets.only(left: 16, right: 16),
          crossAxisCount: 3,
          crossAxisSpacing: 18,
          mainAxisSpacing: 18,
          children: myList.map((data) {
            return GestureDetector(
            onTap: data.callAction,
            child: new Container(
              decoration: BoxDecoration(
                  color: bgColor, borderRadius: BorderRadius.circular(10)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    data.img,
                    width: 42,
                  ),
                  SizedBox(
                    height: 14,
                  ),
                  Text(
                    data.title,
                    style: GoogleFonts.openSans(
                        textStyle: TextStyle(
                            color: fontColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
            )
          );
          }).toList()),
    );
  }
}

class Items {
  String title;
  String img;
  final void Function() callAction;

  Items({this.title, this.img, this.callAction});
}
