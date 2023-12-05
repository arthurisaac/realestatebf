import 'package:flutter/material.dart';

import 'constants.dart';

class UiUtils {
  static void setSnackBar(String title, String msg, BuildContext context, bool showAction, {Function? onPressedAction, Duration? duration}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                textAlign: showAction ? TextAlign.start : TextAlign.start,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 14.0)),
            const SizedBox(height: 5.0),
            Text(msg,
                textAlign: showAction ? TextAlign.start : TextAlign.start,
                maxLines: 2,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12.0,
                  fontWeight: FontWeight.normal,
                )),
          ],
        ),
      ),
      behavior: SnackBarBehavior.floating,
      duration: duration ?? const Duration(seconds: 2),
      backgroundColor: Theme.of(context).primaryColor,
      action: showAction
          ? SnackBarAction(
        label: "Retry",
        onPressed: onPressedAction as void Function(),
        textColor: Colors.white,
      )
          : null,
      elevation: 2.0,
    ));
  }

  static Widget alertButtonWidget(String title, String image, double width, onPressed) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(space / 2),
      child: SizedBox(
        width: double.infinity,
        child: Stack(
          children: [
            Container(
              width: width * 0.5,
              height: 52,
              margin: const EdgeInsets.all(5),
              padding: EdgeInsets.only(left: width * 0.02),
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                  color: const Color(0xFFd96e70),
                  borderRadius: BorderRadius.circular(space / 2)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(image),
              ),
            ),
            Positioned(
              right: 5,
              top: 4,
              child: Container(
                width: width * 0.7,
                height: 55,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: const Color(0xFFe9e7e8),
                    borderRadius: BorderRadius.circular(space / 2)),
                child: Text(title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static void okAlertDialog(BuildContext context, String title, String message, onPressed) {
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: onPressed,
          child: const Text("OK"),
        )
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  static void msgAlertDialog(BuildContext context, String title, String message, onMessagePressed, onPressed) {
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: onMessagePressed,
          child: const Text("Envoyez un message"),
        ),
        TextButton(
          onPressed: onPressed,
          child: const Text("Annuler"),
        )
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  static void msgAlertDialog2(BuildContext context, String title, String message, onMessagePressed, onPressed) {
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: onMessagePressed,
          child: const Text("Ok"),
        ),
        TextButton(
          onPressed: onPressed,
          child: const Text("Annuler"),
        )
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  static void msgConfirmationDialog(BuildContext context, String title, String message, onMessagePressed, onPressed) {
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: onMessagePressed,
          child: const Text("Oui"),
        ),
        TextButton(
          onPressed: onPressed ??  () {
            Navigator.of(context).pop();
          },
          child: const Text("non"),
        )
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  static void modalLoading(BuildContext context, String title) {
    showDialog(
        barrierDismissible: true,
        context: context,
        builder: (_) {
          return Dialog(
            backgroundColor: Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: space),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // The loading indicator
                  const CircularProgressIndicator(),
                  const SizedBox(
                    height: 15,
                  ),
                  // Some text
                  Text(title)
                ],
              ),
            ),
          );
        });
  }
}