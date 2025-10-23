import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String content) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(content)));
}

Future<File?> pickImage() async {
  try {
    // This line opens the file picker UI on the device.
    final filePickerRes = await FilePicker.platform.pickFiles(
      // Restricts the picker to only show image files.
      type: FileType.image,
    );

    // If the user did select a file, filePickerRes will contain info about the chosen file(s).
    // filePickerRes.files is a list of selected files; here you just take the first one.
    // Then you convert it into a dart:io File object using its path.
    if (filePickerRes != null) {
      return File(filePickerRes.files.first.xFile.path);
    }
    return null;
  } catch (e) {
    return null;
  }
}

// Similar to pickImage, but for audio files.
Future<File?> pickAudio() async {
  try {
    final filePickerRes = await FilePicker.platform.pickFiles(
      type: FileType.audio,
    );

    if (filePickerRes != null) {
      return File(filePickerRes.files.first.xFile.path);
    }
    return null;
  } catch (e) {
    return null;
  }
}
