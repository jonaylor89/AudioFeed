import 'dart:io';

import 'package:audio_feed/components/audio_container.dart';
import 'package:audio_feed/components/file_picker_button.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class AudioFeedView extends StatefulWidget {
  const AudioFeedView({Key? key}) : super(key: key);

  @override
  _AudioFeedViewState createState() => _AudioFeedViewState();
}

class _AudioFeedViewState extends State<AudioFeedView> {
  // final String driveId = "1bW1jBGWLCJQPkrtS5Mkal5Dc8mxAnsfB";
  // final String audioFolderURL =
  //     "https://drive.google.com/drive/folders/1bW1jBGWLCJQPkrtS5Mkal5Dc8mxAnsfB?usp=sharing";

  // List<File> audioFiles = [];
  File? _pickedAudio;

  // void fetchAudioFiles() async {
  //   final httpClient = await clientViaApplicationDefaultCredentials(scopes: [
  //     DriveApi.driveReadonlyScope,
  //   ]);
  //
  //   try {
  //     final drive = DriveApi(httpClient);
  //
  //     final driveFiles = await drive.files.list(driveId: driveId);
  //     final List<File> audioFiles = driveFiles.files!;
  //     print('Received ${audioFiles.length} file names:');
  //     for (var file in audioFiles) {
  //       print(file.name);
  //     }
  //
  //     this.audioFiles = audioFiles;
  //   } finally {
  //     httpClient.close();
  //   }
  // }

  void handleAudioFromFiles() async {
    try {
      FilePickerResult? audioFileResult = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['mp3'],
      );
      if (audioFileResult != null) {
        final String path = audioFileResult.files.single.path!;

        File pickedAudio = File(path);

        setState(() {
          _pickedAudio = pickedAudio;
        });
      }
    } catch (error) {
      print(error);
    }
  }

  @override
  void initState() {
    // fetchAudioFiles();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('Audio Feed'),
        ),
      ),
      floatingActionButton: FilePickerButton(
        onTap: handleAudioFromFiles,
      ),
      body: Center(
        child: Column(
          children: [
            _pickedAudio == null
                ? const SizedBox.shrink()
                : AudioContainer(
                    audioFile: _pickedAudio!,
                  ),
          ],
        ),
      ),
    );
  }
}
