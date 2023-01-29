import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:music_app/database/song_db.dart';
import 'package:music_app/widgets/animated_text.dart';
import 'package:music_app/widgets/neu_box_widget.dart';
import 'package:music_app/screens/playlist_folder.dart';
import 'package:provider/provider.dart';
import '../database/playlist_functions.dart';

class PlaylistScreen extends StatefulWidget {
  const PlaylistScreen({super.key});

  @override
  State<PlaylistScreen> createState() => _PlaylistScreenState();
}

final nameController = TextEditingController();
final _formKey = GlobalKey<FormState>();

class _PlaylistScreenState extends State<PlaylistScreen> {
  late final Songs playlist;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: const Text('Playlist',
            style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.black)),
        backgroundColor: Colors.grey[300],
      ),
      body: Consumer<PlaylistDB>(
        builder: (context, value, child) => value.boxNotifier.isEmpty
            ? const Center(
                child: Text(
                  'No playlist found',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              )
            : Consumer<PlaylistDB>(
                builder: (BuildContext context, provider, Widget? child) {
                return GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2),
                    itemCount: provider.boxNotifier.length,
                    itemBuilder: ((context, index) {
                      final data = provider.boxNotifier.values.toList()[index];
                      return Padding(
                        padding: const EdgeInsets.all(15),
                        child: InkWell(
                          child: NeuBox(
                              child: Card(
                            elevation: 0,
                            color: Colors.grey[300],
                            child: Padding(
                              padding: const EdgeInsets.all(0),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  AnimatedText(
                                    text: data.name,
                                    style: const TextStyle(fontSize: 30),
                                  ),
                                  TextButton(
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              backgroundColor: Colors.grey[300],
                                              title:
                                                  const Text('Delete Playlist'),
                                              content: const Text(
                                                  'Are you sure you want to delete this playlist ? '),
                                              actions: [
                                                TextButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: const Text(
                                                      'No',
                                                      style: TextStyle(
                                                          color: Colors.red),
                                                    )),
                                                TextButton(
                                                    onPressed: () {
                                                      // provider.boxNotifier
                                                      //     .deleteAt(index);
                                                      provider.playlistDelete(
                                                          index);
                                                      provider
                                                          .notifyListeners();

                                                      Navigator.pop(context);

                                                      // provider.playlistNotifier
                                                      //     .removeAt(index);
                                                    },
                                                    child: const Text(
                                                      'Yes',
                                                      style: TextStyle(
                                                          color: Colors.red),
                                                    )),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                      child: const Text(
                                        'Delete',
                                        style: TextStyle(color: Colors.red),
                                      ))
                                ],
                              ),
                            ),
                          )),
                          onTap: () {
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: (context) {
                              return PlaylistFolder(
                                playlist: data,
                                folderIndex: index,
                              );
                            }));
                          },
                        ),
                      );
                    }));
              }),
      ),
      floatingActionButton: SizedBox(
        height: 50,
        width: 70,
        child: NeuBox(
          child: TextButton(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.grey[300])),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return Dialog(
                    backgroundColor: Colors.grey[300],
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)),
                    child: SizedBox(
                      height: 250,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Center(
                              child: Text(
                                'Create Your Playlist',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            Form(
                              key: _formKey,
                              child: TextFormField(
                                  autofocus: true,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  controller: nameController,
                                  decoration: InputDecoration(
                                    labelText: 'Playlist Name',
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                  ),
                                  validator: (value) {
                                    bool check = playlistNameCheck(value);

                                    if (value!.isEmpty) {
                                      return "Playlist Name is required";
                                    } else if (check) {
                                      return "$value already exist in playlist ";
                                    } else {
                                      return null;
                                    }
                                  }),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                SizedBox(
                                    width: 100.0,
                                    child: SizedBox(
                                      height: 50,
                                      child: NeuBox(
                                        child: TextButton(
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    Colors.grey[300]),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text(
                                              'Cancel',
                                              style:
                                                  TextStyle(color: Colors.red),
                                            )),
                                      ),
                                    )),
                                SizedBox(
                                    width: 100.0,
                                    child: SizedBox(
                                      height: 50,
                                      child: NeuBox(
                                        child: TextButton(
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    Colors.grey[300]),
                                            onPressed: () {
                                              if (_formKey.currentState!
                                                  .validate()) {
                                                whenButtonClicked();

                                                Navigator.of(context).pop();
                                                Provider.of<PlaylistDB>(context,
                                                        listen: false)
                                                    .notifyListeners();
                                              }
                                            },
                                            child: const Text(
                                              'Save',
                                              style:
                                                  TextStyle(color: Colors.red),
                                            )),
                                      ),
                                    ))
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
            child: const Icon(
              Icons.add,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  bool playlistNameCheck(name) {
    bool result = false;

    for (int i = 0;
        i <
            Provider.of<PlaylistDB>(context, listen: false)
                .playlistNotifier
                .length;
        i++) {
      if (name ==
          Provider.of<PlaylistDB>(context, listen: false)
              .playlistNotifier[i]
              .name) {
        result = true;
      }
      if (result == true) {
        break;
      }
    }
    return result;
  }

  Future<void> whenButtonClicked() async {
    final name = nameController.text.trim();
    if (name.isEmpty) {
      return;
    } else {
      final music = Songs(
        songIds: [],
        name: name,
      );
      Provider.of<PlaylistDB>(context, listen: false).playlistAdd(music);
      Provider.of<PlaylistDB>(context, listen: false).notifyListeners();
      nameController.clear();
    }
  }
}
