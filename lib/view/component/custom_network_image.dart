import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CustomImageNetwork extends StatelessWidget {
  final String? image;
  final double height;
  final double width;
  final double radius;

  const CustomImageNetwork(
      {Key? key,
      required this.image,
      this.height = 120,
      this.width = 120,
      this.radius = 16})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.pinkAccent),
        borderRadius: BorderRadius.circular(radius),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: CachedNetworkImage(
          fit: BoxFit.cover,
          imageUrl: image ?? "",
          progressIndicatorBuilder: (context, text, DownloadProgress value) {
            return Container(
              height: height,
              width: width,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.pinkAccent),
                color: Colors.grey.withOpacity(0.4),
                borderRadius: BorderRadius.circular(radius),
              ),
              child:
                  Center(child: Text(((value.progress ?? 1) * 100).toString())),
            );
          },
          errorWidget: (context, _, __) {
            return Container(
                height: height,
                width: width,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  border: Border.all(color: Colors.pinkAccent),
                  borderRadius: BorderRadius.circular(radius),
                ),
                child: const Center(child: Icon(Icons.error)));
          },
        ),
      ),
    );
  }
}
