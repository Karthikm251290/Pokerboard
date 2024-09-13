// lib/widgets/estimation_card.dart
import 'package:flutter/material.dart';

class EstimationCard extends StatelessWidget {
  final String value;
  final bool isSelected;
  final VoidCallback onTap;

  EstimationCard({
    required this.value,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: isSelected ? Colors.blueAccent : Colors.white,
        elevation: isSelected ? 8.0 : 2.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
          side: isSelected
              ? BorderSide(color: Colors.blue, width: 2.0)
              : BorderSide(color: Colors.grey.shade300),
        ),
        child: Container(
          width: 80,
          height: 100,
          alignment: Alignment.center,
          child: Text(
            value,
            style: TextStyle(
              fontSize: 24.0,
              color: isSelected ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
