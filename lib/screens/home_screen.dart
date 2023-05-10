import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../base_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  late TabController _tabController;
  // Future<List<String>> getPaths() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   List<String> paths = prefs.getStringList('file_paths') ?? [];
  //   return paths;
  // }

  // List<String>? paths;

  @override
  void initState() {
    // getPaths().then((p) => paths = p);
    _tabController = TabController(length: 3, vsync: this);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // base provider
    final baseProvider = Provider.of<BaseProvider>(context, listen: false);
    final labaratoriesFiles = Provider.of<BaseProvider>(context, listen: false).labaratoriesFiles;
    final speechsFiles = Provider.of<BaseProvider>(context, listen: false).speechsFiles;
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
          ],
          bottom: TabBar(
            controller: _tabController,
            tabs: [
              const Tab(
                child: Text('Maruzalar'),
              ),
              const Tab(
                child: Text('Labaratoriyalar'),
              ),
              InkWell(
                highlightColor: Colors.transparent,
                hoverColor: Colors.transparent,
                splashColor: Colors.transparent,
                onTap: () async {
                  const url = 'https://appetize.io/demo?device=iphone8&osVersion=13.7&scale=75';
                  if (await canLaunchUrl(Uri.parse(url))) {
                    await launchUrl(Uri.parse(url));
                  } else {
                    throw 'Could not launch $url';
                  }
                },
                child: const Tab(
                  child: Text('Emulator'),
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            Stack(
              children: [
                ListView.builder(
                  itemCount: (speechsFiles).length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: const CircleAvatar(
                        child: Icon(Icons.insert_drive_file),
                      ),
                      title: Text((speechsFiles)[index].path.split('/')[(speechsFiles)[index].path.split('/').length - 1]),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_forever),
                        onPressed: () {
                          baseProvider
                              .deleteSpeechsPath(
                            (speechsFiles)[index],
                          )
                              .then((value) {
                            setState(() {});
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
                      Provider.of<BaseProvider>(context, listen: false).pickerSpeechsFile().then((value) {
                        setState(() {});
                      });
                    },
                    child: const Icon(Icons.add),
                  ),
                )
              ],
            ),
            Stack(
              children: [
                ListView.builder(
                  itemCount: (labaratoriesFiles).length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: const CircleAvatar(
                        child: Icon(Icons.insert_drive_file),
                      ),
                      title: Text((labaratoriesFiles)[index].path.split('/')[(labaratoriesFiles)[index].path.split('/').length - 1]),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_forever),
                        onPressed: () {
                          baseProvider
                              .deleteSpeechsPath(
                            (speechsFiles)[index],
                          )
                              .then((value) {
                            setState(() {});
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
                      baseProvider.pickerLabaratoriesFile().then((value) {
                        setState(() {});
                      });
                    },
                    child: const Icon(Icons.add),
                  ),
                )
              ],
            ),
            const Center(
              child: Text('Emulator'),
            )
          ],
        ));
  }
}
