import 'package:animated_splash_screen/animated_splash_screen.dart';
//import 'package:lamundialapp/Negocio/pagar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:lamundialapp/pages/Sales/BeneficiariesForm.dart';
import 'package:lamundialapp/pages/Sales/RiskStatement.dart';
import 'package:lamundialapp/pages/Sales/VerifyPayment.dart';
import 'package:lamundialapp/pages/rolPage.dart';
import 'pages/login_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  //const MyApp({super.key});
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('es'), Locale('fr')],
      debugShowCheckedModeBanner: false,
      title: 'LA MUNDIAL',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AnimatedSplashScreen(
        splash: Image.asset("assets/animation.gif"),
        duration: 4000,
        splashTransition: SplashTransition.scaleTransition,
        backgroundColor: const Color.fromARGB(255, 251, 251, 251),
        nextScreen: const RolPage(),
        //nextScreen: const VerifyPaymentPage(),
        splashIconSize: MediaQuery.of(context).size.height,
      ),
      //home: LoginPage(),
    );
  }
}
