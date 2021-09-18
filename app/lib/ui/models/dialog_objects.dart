import 'package:flutter/material.dart';

/// This class hold the information sent to a dialog. It is especially used for information dialogs with a simple title and content.
/// You can add a title and content message as far as the onOk and onCancel functionality.
/// OnOkPush, onOkPush and dialogColored are flags to set a special functionality without defining a special dialog.
class InfoDialogObject {
  String title;
  String content;
  VoidCallback onOk;
  VoidCallback onCancel;
  bool onOkPop;
  bool onOkPush;
  bool dialogColored;

  InfoDialogObject(this.title, this.content, this.onOk, this.onCancel,
      this.onOkPop, this.onOkPush, this.dialogColored);
}

/// This class hold the information sent to a dialog. It is especially used for progress dialogs with a progress-text.
/// You can add a title, content and progress message as far as the onOk and onCancel functionality.
/// OnOkPush and showCancel are two flags to set a special functionality without defining a special dialog.
class ProgressDialogObject {
  String title;
  String content;
  String progress;
  VoidCallback onOk;
  VoidCallback onCancel;
  bool onOkPush;
  bool showCancel;

  ProgressDialogObject(
      {required this.title,
      required this.content,
      required this.progress,
      required this.onOk,
      required this.onCancel,
      required this.onOkPush,
      required this.showCancel});
}
