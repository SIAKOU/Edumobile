import 'package:flutter/material.dart';

class AttachmentSelector extends StatelessWidget {
  final void Function()? onImage;
  final void Function()? onFile;

  const AttachmentSelector({
    super.key,
    this.onImage,
    this.onFile,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.photo),
          onPressed: onImage,
          tooltip: "Image",
        ),
        IconButton(
          icon: const Icon(Icons.attach_file),
          onPressed: onFile,
          tooltip: "Fichier",
        ),
      ],
    );
  }
}