import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class Avatar extends StatelessWidget {
  const Avatar({
    Key key,
    @required this.photoUrl,
    @required this.radius,
    this.avatarBackgroundColor = Colors.black,
    this.borderColor,
    this.borderWidth,
  }) : super(key: key);
  final String photoUrl;
  final double radius;
  final Color borderColor;
  final Color avatarBackgroundColor;
  final double borderWidth;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: _borderDecoration(),
      child: CircleAvatar(
        radius: radius,
        backgroundColor: avatarBackgroundColor,
        backgroundImage: photoUrl != null ? NetworkImage(photoUrl) : null,
        child: photoUrl == null
            ? Icon(Icons.perm_identity, size: radius * 1.2)
            : null,
      ),
    );
  }

  Decoration _borderDecoration() {
    if (borderColor != null && borderWidth != null) {
      return BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: borderColor,
          width: borderWidth,
        ),
      );
    }
    return null;
  }
}
