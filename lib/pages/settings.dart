import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../providers/user_provider.dart';

class Settings extends ConsumerStatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  ConsumerState<Settings> createState() => _SettingsState();
}

class _SettingsState extends ConsumerState<Settings> {
  final TextEditingController _namecontroller =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    LocalUser currentUser = ref.watch(userProvider);
    _namecontroller.text = currentUser.user.name;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(children: [
          GestureDetector(
            onTap: () async {
              final ImagePicker picker = ImagePicker();
              final XFile? pickedImage =
                  await picker.pickImage(
                      source: ImageSource.gallery,
                      requestFullMetadata: false);
              if (pickedImage != null) {
                ref
                    .read(userProvider.notifier)
                    .updatePicture(File(pickedImage.path));
              }
            },
            child: CircleAvatar(
                radius: 100,
                foregroundImage: NetworkImage(
                    currentUser.user.profilePic)),
          ),
          const SizedBox(
            height: 10,
          ),
          const Center(
            child: Text("Tap Image to Change"),
          ),
          TextFormField(
            decoration: const InputDecoration(
                labelText: "Enter your name"),
            controller: _namecontroller,
          ),
          TextButton(
              onPressed: () {
                ref
                    .read(userProvider.notifier)
                    .updateName(_namecontroller.text);
              },
              child: const Text("Update"))
        ]),
      ),
    );
  }
}
