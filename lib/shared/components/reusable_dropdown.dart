import 'package:flutter/material.dart';

class ReusableDropdownButton extends StatefulWidget {
  final List<String> items;
  final String value;
  final void Function(String) onChanged;
  const ReusableDropdownButton({
    super.key,
    required this.items,
    required this.value,
    required this.onChanged,
  });

  @override
  State<ReusableDropdownButton> createState() => _ReusableDropdownButtonState();
}

class _ReusableDropdownButtonState extends State<ReusableDropdownButton> {
  late String selectedValue;

  @override
  void initState() {
    super.initState();
    selectedValue = widget.items.first; // Set initial value
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: selectedValue,
      items: widget.items.map((String item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(item),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          selectedValue = newValue!;
        });
        widget.onChanged(newValue!);
      },
    );
  }
}
