import 'package:flutter/material.dart';

class FilePickerButton extends StatefulWidget {
  const FilePickerButton({Key? key, required this.onTap}) : super(key: key);

  final void Function()? onTap;

  @override
  _FilePickerButtonState createState() => _FilePickerButtonState();
}

class _FilePickerButtonState extends State<FilePickerButton> {
  void Function()? get _onTap => widget.onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: GestureDetector(
        onTap: _onTap,
        child: Container(
          height: 60,
          width: 60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
            border: Border.all(
              color: Colors.deepPurple,
              width: 2,
            ),
          ),
          child: const Icon(
            Icons.music_note,
            size: 40,
            color: Colors.deepPurple,
          ),
        ),
      ),
    );
  }
}
