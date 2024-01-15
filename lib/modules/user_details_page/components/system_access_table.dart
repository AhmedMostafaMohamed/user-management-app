import 'package:flutter/material.dart';

class SystemAccessTable extends StatelessWidget {
  final Map<String, bool> systems;
  final List<String> labels;
  final void Function(bool?,String) onAccessChanged;
  const SystemAccessTable(
      {super.key,
      required this.systems,
      required this.labels,
      required this.onAccessChanged});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height * 0.7;
    return SizedBox(
      height: height,
      child: ListView(
        children: [
              _buildTableHeader(context),
            ] +
            List.generate(
                systems.length,
                (index) => _buildDataRow(systems.keys.elementAt(index),
                    systems.values.elementAt(index))),
      ),
    );
  }

  Widget _buildDataRow(String name, bool access) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(child: Text(name)),
          Expanded(
              child: Checkbox(
            onChanged: (value) {
              onAccessChanged(value,name);
            },
            value: access,
          )),
        ],
      ),
    );
  }

  Widget _buildTableHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        children: List.generate(
            labels.length,
            (index) => Expanded(
                  child: Text(
                    labels[index],
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                )),
      ),
    );
  }
}
