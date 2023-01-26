import 'package:flutter/material.dart';
import '../widgets/custom_alert_dialogues.dart';

showErrorAlert(context) {
  var alert = CustomGeneralAlertDialogue(
    title: 'Error Occured!',
    subtitle: 'There is an error, please try again later.',
    action: () {
      Navigator.pop(context);
    },
    actionTitle: 'Okay',
  );
  showDialog(context: context, builder: (context) => alert);
}
