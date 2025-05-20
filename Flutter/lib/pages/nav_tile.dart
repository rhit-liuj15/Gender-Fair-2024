import 'package:flutter/material.dart';

class NavTile extends StatefulWidget {
	/// A tile used for the top navbar that responds to clicks and can become highlighted
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const NavTile({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  _NavTileState createState() => _NavTileState();
}

class _NavTileState extends State<NavTile> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    // Use theme-based colors
    final primaryColor = colorScheme.primary;
    final selectedTextColor = colorScheme.onPrimary;
    final defaultTextColor = colorScheme.onSurface;

    Color tileColor;
    Color textColor;

    if (widget.isSelected) {
      tileColor = primaryColor;
      textColor = selectedTextColor;
    } else if (_isHovered) {
      tileColor = primaryColor.withOpacity(0.1);
      textColor = primaryColor;
    } else {
      tileColor = Colors.transparent;
      textColor = defaultTextColor;
    }

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: InkWell(
        onTap: widget.onTap,
        borderRadius: BorderRadius.circular(6),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: tileColor,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Center(
            child: Text(
              widget.label,
              style: TextStyle(
                color: textColor,
                fontWeight: widget.isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
