import 'package:flutter/material.dart';

class FilterBlockWithHeader extends StatefulWidget {
  final String title;
  final Widget child;

  FilterBlockWithHeader({
    super.key,
    required this.title,
    required this.child,
  });

  @override
  State<FilterBlockWithHeader> createState() => _FilterBlockWithHeaderState();
}

class _FilterBlockWithHeaderState extends State<FilterBlockWithHeader> {
  bool isVisible = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                icon: isVisible
                    ? const Icon(
                        Icons.add,
                      )
                    : const Icon(
                        Icons.remove,
                      ),
                onPressed: () {
                  setState(() {
                    isVisible = !isVisible;
                  });
                },
              ),
              const SizedBox(width: 14.0),
              Expanded(
                child: Text(
                  widget.title,
                  style: const TextStyle(
                      fontSize: 24.0, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.start,
                ),
              ),
            ],
          ),
          Visibility(
            visible: isVisible,
            child: Column(
              children: [
                const SizedBox(height: 20.0),
                Padding(
                  padding: const EdgeInsets.only(left: 35.0, right: 35.0),
                  child: widget.child,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
