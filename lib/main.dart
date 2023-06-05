import 'package:file_manager/providers/base_provider.dart';
import 'package:file_manager/providers/main_provider.dart';
import 'package:file_manager/screens/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'screens/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseApp app = await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: 'AIzaSyC1zZKBqkgFITtSlXvb6i53wlz_10_ObVA',
      appId: '1:887930857034:android:e9ff99f5c94a7b56e628b3',
      messagingSenderId: '887930857034',
      projectId: 'my-web-app-cc2b0',
      databaseURL: 'https://my-web-app-cc2b0-default-rtdb.firebaseio.com',
      storageBucket: 'my-web-app-cc2b0.appspot.com',
    ),
  );
  final FirebaseAuth auth = FirebaseAuth.instanceFor(app: app);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => BaseProvider()),
        ChangeNotifierProvider(create: (context) => AuthProvider(auth)),
        ChangeNotifierProvider(create: (context) => CustomFileProvider(auth)),
      ],
      child: const MainRoot(),
    ),
  );
}

class MainRoot extends StatefulWidget {
  const MainRoot({super.key});

  @override
  State<MainRoot> createState() => _MainRootState();
}

class _MainRootState extends State<MainRoot> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
      ),
      title: 'File Picker Demo',
      routes: {
        '/': (context) => const LoginScreen(),
        'home': (context) => const HomeScreen(),
      },
    );
  }
}
