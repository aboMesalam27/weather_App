import 'package:flutter/material.dart';
import 'package:splash_screen_view/SplashScreenView.dart';

import 'home_screen.dart';
import 'package:google_fonts/google_fonts.dart';
main(){
  runApp( const Weather());
}
class Weather extends StatelessWidget {
  const Weather({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      theme: ThemeData(
        textTheme:GoogleFonts.cairoTextTheme(Theme.of(context).textTheme)
      ),
      title: "Weather",
      debugShowCheckedModeBanner: false,
      home:  Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.contain,
                image:AssetImage("assets/images/Weather-cuate.png")
            )
        ),
        child: SplashScreenView(
          imageSrc: 'assets/images/Weather-cuate.png',
          imageSize: 300,


          duration: 7070,
          navigateRoute: HomeScreen(),
        ),
      ),
    );
  }
}
