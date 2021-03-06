import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class Avatar extends StatelessWidget {
  const Avatar({
    Key key,
    @required this.photoUrl,
    @required this.radius,
    this.avatarBackgroundColor,
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
        backgroundColor:
            avatarBackgroundColor ?? Theme.of(context).colorScheme.primary,
        backgroundImage: photoUrl != null && photoUrl.isNotEmpty
            ? _getNetworkImage(photoUrl)
            : null,
        child: photoUrl == null || photoUrl.isEmpty
            ? Icon(
                Icons.perm_identity,
                size: radius * 1.2,
                color: Theme.of(context).colorScheme.primaryVariant,
              )
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

  NetworkImage _getNetworkImage(String photoUrl) {
    NetworkImage result;
    try {
      result = NetworkImage(photoUrl);
    } catch (e, stacktrace) {
      print(e);
      print(stacktrace);
    }
    return result;
  }
}
