import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../features/utility/const/constant_color.dart';

enum CustomImageType { standart, doctor }

class CustomImage {
  static Widget image(
    String imageUrl,
    CustomImageType type, {
    EdgeInsetsGeometry errorWidgetPadding = const EdgeInsetsGeometry.all(0),
    BoxFit fit = BoxFit.contain,
  }) {
    return Image(
      image: CachedNetworkImageProvider(imageUrl),
      loadingBuilder:
          (
            BuildContext context,
            Widget child,
            ImageChunkEvent? loadingProgress,
          ) {
            final totalBytes = loadingProgress?.expectedTotalBytes;
            final bytesLoaded = loadingProgress?.cumulativeBytesLoaded;
            if (totalBytes != null && bytesLoaded != null) {
              return CircularProgressIndicator(
                backgroundColor: Colors.white70,
                value: bytesLoaded / totalBytes,
                color: Colors.blue[900],
                strokeWidth: 5.0,
              );
            } else {
              return child;
            }
          },
      frameBuilder:
          (
            BuildContext context,
            Widget child,
            int? frame,
            bool wasSynchronouslyLoaded,
          ) {
            if (wasSynchronouslyLoaded) {
              return child;
            }
            return AnimatedOpacity(
              opacity: frame == null ? 0 : 1,
              duration: const Duration(seconds: 1),
              curve: Curves.easeOut,
              child: child,
            );
          },
      fit: fit, // fit özelliğini kullanıyoruz
      errorBuilder:
          (BuildContext context, Object exception, StackTrace? stackTrace) {
            switch (type) {
              case CustomImageType.doctor:
                return Image(
                  image: const CachedNetworkImageProvider(
                    "https://kiosk.prtk.gen.tr/assets/images/doctor/default.png",
                  ),
                  fit: fit,
                  errorBuilder: (_, __, ___) =>
                      const Icon(Icons.person, color: ConstColor.grey),
                );
              default:
                return const Icon(Icons.error, color: ConstColor.red);
            }
          },
    );
  }
}
