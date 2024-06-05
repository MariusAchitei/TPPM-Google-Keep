import 'package:flutter/material.dart';
import 'package:keep/pages/home_page.dart';
import 'package:provider/provider.dart';
import 'providers/theme_provider.dart';
import 'services/note_service.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        Provider(create: (_) => NoteService()..loadNotes()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'Google Keep',
            theme:
                themeProvider.isDarkMode ? ThemeData.dark() : ThemeData.light(),
            home: HomePage(),
          );
        },
      ),
    );
  }
}
