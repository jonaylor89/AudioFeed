import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:audio_feed/components/audio_container.dart';
import 'package:flutter/material.dart';

class AudioFeedView extends StatelessWidget {
  AudioFeedView({Key? key}) : super(key: key);

  ValueNotifier<String> audioLock = ValueNotifier('');

  final String cloudFunctionUrl =
      "https://us-central1-audio-feed-328918.cloudfunctions.net/list-drive-files";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('Audio Feed'),
        ),
      ),
      body: Center(
        child: FutureBuilder<http.Response>(
          future: http.get(Uri.parse(cloudFunctionUrl)),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const CircularProgressIndicator();
            }

            final response = snapshot.data!;
            final List<dynamic> loops = jsonDecode(response.body)["files"];
            return ListView.builder(
              itemCount: loops.length,
              itemBuilder: (context, index) {
                final Map<String, dynamic> loop = loops[index];
                return AudioContainer(
                  audioTitle: loop["name"]! as String,
                  audioId: loop["id"]! as String,
                  audioLock: audioLock,
                );
              },
            );
          },
        ),
      ),
    );
  }
}
