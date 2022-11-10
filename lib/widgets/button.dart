

import 'package:flutter/material.dart';

Widget custombutten({
  required String title,
  required IconData icon,
  required VoidCallback onClick,
}) {
  return ElevatedButton(
      onPressed: onClick,
      child: Row(
        children: [Icon(icon), Text(title)],
      ));
}


