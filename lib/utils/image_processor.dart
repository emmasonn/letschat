import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

ImageProvider getImage(String path) {
  if (path.startsWith('http://') || path.startsWith('https://')) {
    // log('Coming with http: $path');
    return CachedNetworkImageProvider(path);
  } else if (path.contains('assets')) {
    // log('Coming without http: $path');
    return AssetImage(path);
  } else {
    // log('Coming without http: $path');
    return FileImage(File(path));
  }
}

Widget loadImageWidget(String path, {BoxShape? shape}) {
  return Container(
    clipBehavior: Clip.hardEdge,
    decoration: BoxDecoration(
      shape: shape ?? BoxShape.circle,
    ),
    child: path.isEmpty
        ? const Icon(FontAwesomeIcons.person)
        : getImageWidget(path),
  );
}

Widget getImageWidget(String path) {
  if (path.startsWith('http://') || path.startsWith('https://')) {
    // log('Coming with http: $path');
    return CachedNetworkImage(
      imageUrl: path,
      placeholder: (context, url) => const SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator.adaptive(),
      ),
      errorWidget: (context, url, error) =>
          const Center(child: Icon(Icons.error)),
      fit: BoxFit.cover,
    );
  } else if (path.contains('assets')) {
    // log('Coming without http: $path');
    return Image.asset(path, fit: BoxFit.cover);
  } else {
    // log('Coming without http: $path');
    return Image.file(File(path), fit: BoxFit.cover);
  }
}
