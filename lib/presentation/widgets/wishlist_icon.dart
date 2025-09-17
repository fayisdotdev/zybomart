import 'package:flutter/material.dart';

class WishlistIcon extends StatelessWidget {
  final bool isWish;
  final VoidCallback onTap;
  const WishlistIcon({super.key, required this.isWish, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTap,
      icon: Icon(isWish ? Icons.favorite : Icons.favorite_border, color: isWish ? Colors.red : Colors.grey),
    );
  }
}
