import 'package:badges/badges.dart';
import 'package:flutter/material.dart';

class CacheBadge extends StatelessWidget {
  const CacheBadge({
    Key key,
    @required this.hasCacheProfile,
    @required this.child,
  }) : super(key: key);

  final bool hasCacheProfile;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Badge(
        showBadge: hasCacheProfile,
        badgeColor: Colors.orange,
        badgeContent: Text(''),
        position: BadgePosition(
          right: 5.0,
          top: 2.0,
        ),
        shape: BadgeShape.circle,
        child: child);
  }
}
