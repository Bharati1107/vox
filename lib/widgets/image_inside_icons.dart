import 'package:flutter/material.dart';

imageInsideIcons(
  height,
  imgPath,
  color,
) {
  // print(isAllow);
  return Stack(
    children: [
      Container(
        height: height,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            image: DecorationImage(
              image: NetworkImage(imgPath),
              fit: BoxFit.cover,
            )),
      ),
      Positioned(
        top: 20,
        left: 10,
        child: Icon(
          Icons.arrow_back_ios_sharp,
          size: 14,
          color: color,
        ),
      ),
      iconInsideImage(20.0, 10.0, Icons.bookmark, color),
    ],
  );
}

Positioned iconInsideImage(top, right, icon, color) {
  return Positioned(
    top: top,
    right: right,
    child: Icon(
      icon,
      size: 14,
      color: color,
    ),
  );
}
