import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../base_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  // Future<List<String>> getPaths() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   List<String> paths = prefs.getStringList('file_paths') ?? [];
  //   return paths;
  // }

  // List<String>? paths;

  @override
  void initState() {
    // Permission.location.request();
    Permission.storage.request();
    // getPaths().then((p) => paths = p);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final paths = Provider.of<BaseProvider>(context, listen: false).paths;
    // print(paths);
    return Scaffold(
        key: _key,
        appBar: AppBar(
          title: const Text('File Picker'),
          actions: [
            IconButton(
              onPressed: () {
                setState(() {});
              },
              icon: const Icon(Icons.refresh),
            ),
            // IconButton(
            //   onPressed: () {
            //     Provider.of<BaseProvider>(context, listen: false).pickerFile();
            //   },
            //   icon: const Icon(Icons.add),
            // ),
          ],
          bottom: TabBar(
            controller: TabController(length: 3, vsync: this),
            tabs: const [
              Tab(
                child: Text('Maruzalar'),
              ),
              Tab(
                child: Text('Labaratoriyalar'),
              ),
              Tab(
                child: Text('Emulator'),
              ),
            ],
          ),
        ),
        body: TabBarView(
          controller: TabController(length: 3, vsync: this),
          physics: NeverScrollableScrollPhysics(),
          children: [
            Stack(
              children: [
                ListView.builder(
                  itemCount: paths.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    ListTile(
                      leading: const CircleAvatar(
                        child: Icon(Icons.insert_drive_file),
                      ),
                      title: Text((paths[index]!).split('/')[(paths[index]!).split('/').length - 1]),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_forever),
                        onPressed: () {
                          setState(() {
                            Provider.of<BaseProvider>(context, listen: false).deletePath(paths[index]!);
                          });
                        },
                      ),
                    );
                  },
                ),
                Positioned(
                  bottom: 15,
                  right: 15,
                  child: FloatingActionButton(
                    onPressed: () {
                      Provider.of<BaseProvider>(context, listen: false).pickerFile();
                    },
                    child: Icon(Icons.add),
                  ),
                )
              ],
            ),
            Stack(
              children: [
                ListView(
                  shrinkWrap: true,
                  children: (Provider.of<BaseProvider>(context, listen: false).paths)
                      .map(
                        (e) => ListTile(
                          leading: const CircleAvatar(
                            child: Icon(Icons.insert_drive_file),
                          ),
                          title: Text((e!).split('/')[(e).split('/').length - 1]),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete_forever),
                            onPressed: () {
                              Provider.of<BaseProvider>(context, listen: false).deletePath(e);
                            },
                          ),
                        ),
                      )
                      .toList(),
                ),
                Positioned(
                  bottom: 15,
                  right: 15,
                  child: FloatingActionButton(
                    onPressed: () {},
                    child: Icon(Icons.add),
                  ),
                )
              ],
            ),
            Center(
              child: Text('Emulator'),
            )
          ],
        ));
  }
}
