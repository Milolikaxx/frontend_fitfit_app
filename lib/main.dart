import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:frontend_fitfit_app/firebase_options.dart';
import 'package:frontend_fitfit_app/pages/welcome.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
// import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
// import 'package:flutter_localization/flutter_localization.dart';

void main() async {
  Intl.defaultLocale = 'th';
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      // locale: const Locale('th'),
      // debugShowCheckedModeBanner: false,
      // localizationsDelegates: GlobalMaterialLocalizations.delegate,
      // locale: const Locale('th', 'TH'),
      // supportedLocales: const [
      //   Locale('en', 'US'), // English
      //   Locale('th', 'TH'), // Thai
      // ],
      home: const WelcomePage(),
      theme: ThemeData(
        textTheme: GoogleFonts.promptTextTheme(Theme.of(context).textTheme),
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Colors.white,
          selectionColor: Colors.white,
          selectionHandleColor: Colors.white,
        ),
      ),
    );
  }
}
