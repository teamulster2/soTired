import 'package:flutter/material.dart';

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

class ProgressDialogObject {
  String title;
  String content;
  String progress;
  VoidCallback onOk;
  VoidCallback onCancel;
  bool onOkPush;

  ProgressDialogObject(
      {required this.title,
      required this.content,
      required this.progress,
      required this.onOk,
      required this.onCancel,
      required this.onOkPush});
}
