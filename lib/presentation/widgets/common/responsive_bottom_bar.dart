import 'package:flutter/material.dart';

/// Responsive bottom bar widget that handles horizontal scrolling
class ResponsiveBottomBar extends StatelessWidget {
  final List<Widget> children;
  final EdgeInsetsGeometry? padding;
  final double spacing;

  const ResponsiveBottomBar({
    super.key,
    required this.children,
    this.padding,
    this.spacing = 8.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.white, Color(0xFFF8F9FA)],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 12,
            offset: const Offset(0, -4),
            spreadRadius: 2,
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 6,
            offset: const Offset(0, -1),
          ),
        ],
        border: const Border(
          top: BorderSide(color: Color(0xFFE0E0E0), width: 0.5),
        ),
      ),
      child: SafeArea(
        child: Container(
          width: double.infinity,
          padding: padding ?? const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: _buildChildrenWithSpacing(),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildChildrenWithSpacing() {
    if (children.isEmpty) return [];
    
    final List<Widget> spacedChildren = [children.first];
    
    for (int i = 1; i < children.length; i++) {
      // Add spacing before each child (except the first)
      if (children[i] is! Container || 
          (children[i] as Container).constraints?.maxWidth != 1) {
        // Only add spacing if it's not already a divider
        spacedChildren.add(SizedBox(width: spacing));
      }
      spacedChildren.add(children[i]);
    }
    
    return spacedChildren;
  }
}