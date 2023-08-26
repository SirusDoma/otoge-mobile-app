
import 'package:flutter/material.dart';

class SearchNearbyButton extends StatelessWidget {
  const SearchNearbyButton({
    super.key,
    this.onPressed,
    this.duration = const Duration(milliseconds: 200),
    this.visible  = true,
    this.enabled  = true
  });

  final bool visible;
  final bool enabled;
  final Duration duration;
  final Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return AnimatedSlide(
        duration: duration,
        offset: visible ? Offset.zero : const Offset(0, 1),
        child: AnimatedOpacity(
          duration: duration,
          opacity: visible ? 1 : 0,
          child: FloatingActionButton.extended(
            label: const Text('Search for nearby locations', style: TextStyle(color: Colors.white)),
            icon: const Icon(Icons.search, color: Colors.white),
            backgroundColor: Colors.orange.shade700,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            extendedPadding: const EdgeInsets.symmetric(horizontal: 30),
            onPressed: enabled ? onPressed : null,
          ),
        )
    );
  }

}