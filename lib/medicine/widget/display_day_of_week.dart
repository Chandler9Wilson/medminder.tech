import 'package:flutter/material.dart';

class DaySelectionScreen extends StatefulWidget {
  const DaySelectionScreen({super.key, required this.selectedDaysCallback});

  final List<String> selectedDaysCallback;

  @override
  _DaySelectionScreenState createState() => _DaySelectionScreenState();
}

class _DaySelectionScreenState extends State<DaySelectionScreen> {
  List<String> selectedDays = [];

  List<String> daysOfWeek = [
    "Sunday",
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      itemCount: daysOfWeek.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4, // Number of days in a row
          crossAxisSpacing: 10,
          mainAxisSpacing: 10),
      itemBuilder: (context, index) {
        final day = daysOfWeek[index];
        final isSelected = selectedDays.contains(day);

        return GestureDetector(
          onTap: () {
            setState(() {
              if (isSelected) {
                selectedDays.remove(day);
                widget.selectedDaysCallback.remove(day);
              } else {
                selectedDays.add(day);
                widget.selectedDaysCallback.add(day);
              }
            });
          },
          child: Container(
            height: 30,
            width: 30,
            decoration: BoxDecoration(
              border: Border.all(
                color: isSelected ? Colors.blue : Colors.black,
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(10),
              color: isSelected ? Colors.blue : Colors.white,
            ),
            child: Center(
              child: Text(
                day,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
