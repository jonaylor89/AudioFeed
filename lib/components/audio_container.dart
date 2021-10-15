import 'package:audio_feed/components/seek_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';

class AudioContainer extends StatefulWidget {
  const AudioContainer({
    Key? key,
    required this.audioTitle,
    required this.audioId,
    required this.audioLock,
  }) : super(key: key);

  final String audioTitle;
  final String audioId;
  final ValueNotifier<String> audioLock;

  @override
  _AudioContainerState createState() => _AudioContainerState();
}

class _AudioContainerState extends State<AudioContainer>
    with AutomaticKeepAliveClientMixin {
  String get _audioTitle => widget.audioTitle;
  String get _audioId => widget.audioId;
  ValueNotifier<String> get _audioLock => widget.audioLock;

  final String _drivePrefix = "https://drive.google.com/uc?export=view&id=";
  final AudioPlayer _player = AudioPlayer();

  void onAudioLockChange() {
    if (_audioLock.value != _audioId) {
      _player.pause();
    }
  }

  void initAudio() {
    _audioLock.addListener(onAudioLockChange);
    _player.setLoopMode(LoopMode.one);
  }

  @override
  void initState() {
    initAudio();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _player.setUrl(_drivePrefix + _audioId);
    return Column(
      children: [
        const SizedBox(height: 50.0),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Text(
            _audioTitle,
            style: const TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 15.0),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: const BoxDecoration(
            color: Colors.white, //background color of box
          ),
          child: Column(
            children: [
              Row(
                children: [
                  StreamBuilder<PlayerState>(
                    stream: _player.playerStateStream,
                    builder: (context, snapshot) {
                      final playerState = snapshot.data;

                      if (playerState == null) {
                        return const SizedBox.shrink();
                      }

                      final processingState = playerState.processingState;

                      final playing = playerState.playing;
                      if (processingState == ProcessingState.loading ||
                          processingState == ProcessingState.buffering) {
                        return Container(
                          margin: const EdgeInsets.all(8.0),
                          width: 48.0,
                          height: 48.0,
                          child: const CircularProgressIndicator(),
                        );
                      } else if (playing != true) {
                        return IconButton(
                          icon: const Icon(Icons.play_arrow),
                          iconSize: 48.0,
                          onPressed: () {
                            _audioLock.value = _audioId;
                            _player.play();
                          },
                        );
                      } else if (processingState != ProcessingState.completed) {
                        return IconButton(
                          icon: const Icon(Icons.pause),
                          iconSize: 48.0,
                          onPressed: () {
                            _player.pause();
                          },
                        );
                      } else {
                        return IconButton(
                          icon: const Icon(Icons.replay),
                          iconSize: 48.0,
                          onPressed: () => _player.seek(
                            Duration.zero,
                            index: _player.effectiveIndices!.first,
                          ),
                        );
                      }
                    },
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      StreamBuilder<Duration?>(
                        stream: _player.durationStream,
                        builder: (context, snapshot) {
                          final duration = snapshot.data ?? Duration.zero;
                          return StreamBuilder<PositionData>(
                            stream: Rx.combineLatest2<Duration, Duration,
                                    PositionData>(
                                _player.positionStream,
                                _player.bufferedPositionStream,
                                (position, bufferedPosition) =>
                                    PositionData(position, bufferedPosition)),
                            builder: (context, snapshot) {
                              final positionData = snapshot.data ??
                                  PositionData(Duration.zero, Duration.zero);
                              var position = positionData.position;
                              if (position > duration) {
                                position = duration;
                              }
                              var bufferedPosition =
                                  positionData.bufferedPosition;
                              if (bufferedPosition > duration) {
                                bufferedPosition = duration;
                              }
                              return SeekBar(
                                duration: duration,
                                position: position,
                                bufferedPosition: bufferedPosition,
                                onChangeEnd: (newPosition) {
                                  _player.seek(newPosition ?? const Duration());
                                },
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
