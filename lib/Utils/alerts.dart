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

showInfoAlert(context) {
  var alert = CustomGeneralAlertDialogue(
    title: 'Info Alert!',
    subtitle: 'Privacy policy for Hyperspace is currently under development.',
    action: () {
      Navigator.pop(context);
    },
    actionTitle: 'Okay',
  );
  showDialog(context: context, builder: (context) => alert);
}
