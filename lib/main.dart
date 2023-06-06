import 'package:file_manager/base_provider.dart';
import 'package:file_manager/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'screens/home_screen.dart';

void main() {
  runApp(const MainRoot());
}

class MainRoot extends StatelessWidget {
  const MainRoot({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => BaseProvider(),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.indigo,
          ),
        ),
        title: 'File Picker Demo',
        // initialRoute: 'home',
        routes: {
          '/': (context) => const LoginScreen(),
          'home': (context) => const HomeScreen(),
        },
      ),
    );
  }
}
