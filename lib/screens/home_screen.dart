// ignore_for_file: avoid_print

import 'package:file_manager/providers/main_provider.dart';
import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../providers/base_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final userInfo = Provider.of<AuthProvider>(context, listen: false).userInfo;
    // base provider
    final baseProvider = Provider.of<BaseProvider>(context, listen: false);

    return Scaffold(
        key: _key,
        appBar: AppBar(
          backgroundColor: Colors.indigo[400],
          title: const Text(
            'File Picker',
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            IconButton(
              onPressed: () {
                setState(() {});
              },
              icon: const Icon(Icons.refresh),
              color: Colors.white,
            ),
          ],
          bottom: TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white,
            indicatorColor: Colors.indigo[100],
            controller: _tabController,
            tabs: [
              const Tab(
                child: Text('Maruzalar'),
              ),
              const Tab(
                child: Text('Labaratoriya'),
              ),
              InkWell(
                highlightColor: Colors.transparent,
                hoverColor: Colors.transparent,
                splashColor: Colors.transparent,
                onTap: () async {
                  const url = 'https://pythontutor.com/visualize.html#mode=edit';
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
                FutureBuilder(
                  future: Provider.of<BaseProvider>(context, listen: false).getSpeechs(),
                  builder: (context, snapshot) {
                    // final speechsFiles = Provider.of<BaseProvider>(context, listen: false).speechsFiles;
                    return snapshot.connectionState == ConnectionState.waiting
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : snapshot.hasData
                            ? ListView.builder(
                                itemCount: snapshot.data!.length,
                                itemBuilder: (context, index) {
                                  return snapshot == []
                                      ? const Center(
                                          child: Text('No files yet!'),
                                        )
                                      : ListTile(
                                          onTap: () async {
                                            await OpenFilex.open(snapshot.data![index].path).then((value) => print(value.message));
                                          },
                                          leading: const CircleAvatar(
                                            child: Icon(Icons.insert_drive_file),
                                          ),
                                          title: Text(snapshot.data![index].path.split('/').last),
                                          subtitle: Text('From: ${userInfo!.displayName}'),
                                          trailing: IconButton(
                                            icon: const Icon(Icons.delete_forever),
                                            onPressed: () {},
                                          ),
                                        );
                                },
                              )
                            : Center(
                                child: Text(snapshot.error.toString()),
                              );
                  },
                ),
                Positioned(
                  bottom: 15,
                  right: 15,
                  child: FloatingActionButton(
                    onPressed: () {
                      Provider.of<BaseProvider>(context, listen: false).pickerSpeechsFile(context).then((value) {
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
                FutureBuilder(
                  future: Provider.of<BaseProvider>(context, listen: false).getLabaratories(),
                  builder: (context, snapshot) {
                    // final labaratoriesFiles = Provider.of<BaseProvider>(context, listen: false).labaratoriesFiles;
                    return snapshot.connectionState == ConnectionState.waiting
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : snapshot.hasData
                            ? ListView.builder(
                                itemCount: snapshot.data!.length,
                                itemBuilder: (context, index) {
                                  return snapshot.data == []
                                      ? const Center(
                                          child: Text('No files yet!'),
                                        )
                                      : ListTile(
                                          onTap: () {
                                            OpenFilex.open(snapshot.data![index].path);
                                          },
                                          leading: const CircleAvatar(
                                            child: Icon(Icons.insert_drive_file),
                                          ),
                                          title: Text(snapshot.data![index].path.split('/').last),
                                          subtitle: Text('From: ${userInfo!.displayName}'),
                                          trailing: IconButton(
                                            icon: const Icon(Icons.delete_forever),
                                            onPressed: () {},
                                          ),
                                        );
                                },
                              )
                            : Center(
                                child: Text(snapshot.error.toString()),
                              );
                  },
                ),
                Positioned(
                  bottom: 15,
                  right: 15,
                  child: FloatingActionButton(
                    onPressed: () {
                      baseProvider.pickerLabaratoriesFile(context).then((value) {
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
