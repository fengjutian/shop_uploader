import 'dart:io';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../utils/image_util.dart';

class PickedImage {
  final File file;
  final String id;
  PickedImage(this.file, this.id);
}

class ImageGrid extends StatelessWidget {
  final List<PickedImage> images;
  final Function(PickedImage) onAdd;
  final Function(String) onRemove;

  const ImageGrid({
    super.key,
    required this.images,
    required this.onAdd,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
      ),
      itemCount: images.length + 1,
      itemBuilder: (_, i) {
        if (i == images.length) {
          return IconButton(
            icon: const Icon(Icons.add_a_photo),
            onPressed: () async {
              final file = await ImageUtil.pickAndCompress();
              if (file != null) onAdd(PickedImage(file, const Uuid().v4()));
            },
          );
        }
        return Stack(
          children: [
            Image.file(images[i].file, fit: BoxFit.cover),
            Positioned(
              right: 0,
              child: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => onRemove(images[i].id),
              ),
            ),
          ],
        );
      },
    );
  }
}
