import 'package:flutter/material.dart';

class CircleImage extends StatelessWidget {
  final double size;
  final ImageProvider<dynamic> image;
  CircleImage({@required this.size, @required this.image});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: new Container(
          width: size,
          height: size,
          decoration: new BoxDecoration(
              shape: BoxShape.circle,
              image: new DecorationImage(fit: BoxFit.cover, image: image))),
    );
  }
}