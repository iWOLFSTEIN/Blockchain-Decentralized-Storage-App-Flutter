import 'package:flutter/material.dart';
import '../widgets/custom_alert_dialogues.dart';

showErrorAlert(
  context, {
  title: 'Error Occured!',
  subtitle: 'There is an error, please try again later.',
}) {
  var alert = CustomGeneralAlertDialogue(
    title: title,
    subtitle: subtitle,
    action: () {
      Navigator.pop(context);
    },
    actionTitle: 'Okay',
  );
  showDialog(context: context, builder: (context) => alert);
}

showInfoAlert(
  context, {
  title: 'Info Alert!',
  subtitle: 'Privacy policy for Hyperspace is currently under development.',
}) {
  var alert = CustomGeneralAlertDialogue(
    title: title,
    subtitle: subtitle,
    action: () {
      Navigator.pop(context);
    },
    actionTitle: 'Okay',
  );
  showDialog(context: context, builder: (context) => alert);
}
