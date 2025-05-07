import 'package:flutter/material.dart';

Future<DateTime?> showCustomDatePicker({
  required BuildContext context,
  required DateTime initialDate,
  required firstDate, // make optional
  required DateTime lastDate,
}) {
  final today = DateTime.now();
  final validFirstDate = DateTime(today.year, today.month, today.day); // disables past days

  return showDatePicker(
    context: context,
    initialDate: initialDate.isBefore(validFirstDate) ? validFirstDate : initialDate,
    firstDate: firstDate,
    lastDate: lastDate,
    builder: (context, child) {
      return Theme(
        data: Theme.of(context).copyWith(
          datePickerTheme: const DatePickerThemeData(
            backgroundColor: Color(0xFFDBEFF5),
          ),
          colorScheme: const ColorScheme.light(
            primary: Color(0xFF78AFC9),
            onPrimary: Colors.white,
            onSurface: Colors.black,
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(foregroundColor: Color(0xFF78AFC9)),
          ),
        ),
        child: child!,
      );
    },
  );
}
