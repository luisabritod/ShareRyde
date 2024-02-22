import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class CommonMethods {
  checkConectivity(BuildContext context) async {
    var connectionResult = await Connectivity().checkConnectivity();

    if (connectionResult != ConnectivityResult.mobile &&
        connectionResult != ConnectivityResult.wifi) {
      if (!context.mounted) return;
      displaySnackBar(
          context, 'Your connection is not available. Please try again.');
    }
  }

  displaySnackBar(BuildContext context, String messageText) {
    var snackBar = SnackBar(
      content: Text(messageText),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
