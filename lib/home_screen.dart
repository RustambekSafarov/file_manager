import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'base_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<List<String>> getPaths() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> paths = prefs.getStringList('file_paths') ?? [];
    return paths;
  }

  List<String>? paths;

  @override
  void initState() {
    getPaths().then((p) => paths = p);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('File Picker'),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {});
            },
            icon: const Icon(Icons.refresh),
          ),
          IconButton(
            onPressed: () {
              Provider.of<BaseProvider>(context, listen: false).pickerFile();
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: ListView(
        children: (paths ?? [])
            .map(
              (e) => ListTile(
                leading: const CircleAvatar(
                  child: Icon(Icons.insert_drive_file),
                ),
                title: Text((e).split('/')[(e).split('/').length - 1]),
                trailing: IconButton(
                  icon: const Icon(Icons.delete_forever),
                  onPressed: () {},
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
