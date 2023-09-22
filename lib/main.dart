import 'package:flutter/material.dart';
import 'package:flutter_hive_provider/model/users_model.dart';
import 'package:flutter_hive_provider/screens/first_screen.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as pathP;
import 'package:provider/provider.dart';

import 'provider/handle_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final path = await pathP.getApplicationDocumentsDirectory();
  Hive.init(path.path);
  Hive.registerAdapter(UsersModelAdapter());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => HandleProvider(),
        ),
      ],
      builder: (context, child) => const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: FirstScreen(),
      ),
    );
  }
}
