import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:rigging_quiz/utils/constant.dart';
import 'package:rigging_quiz/utils/widget_package.dart';
import 'package:rigging_quiz/widgets/custom_text.dart';

class QImageUpload extends StatefulWidget {
  final void Function(String)? onImageSelected;
  final String? link;
  final String text;
  final IconData icon;
  final bool clipOval;

  const QImageUpload({
    super.key,
    this.onImageSelected,
    this.link,
    this.text = 'Hochladen',
    this.clipOval = false,
    this.icon = Icons.image,
  });

  @override
  State<QImageUpload> createState() {
    return _QImageUploadState();
  }
}

class _QImageUploadState extends State<QImageUpload> {
  Uint8List? _imageData;
  String? _link;
  bool _isLoading = false;

  _imgFromGallery() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _clearImage(); // Clear any previous image
      final fileSize = await pickedFile.length();

      // Check if image size exceeds 1 MB
      if (fileSize > 1048000) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: QColors.highlightColor,
            content: QText(
              text: "Das Bild darf nicht größer als 1 MB sein.",
              color: QColors.white,
            ),
          ),
        );
        return;
      }

      final imageData = await pickedFile.readAsBytes();
      setState(() {
        _isLoading = true;
      });

      try {
        final downloadUrl = await _uploadToFirebaseStorage(imageData);
        if (!mounted) return;
        setState(() {
          _imageData = imageData;
          _link = downloadUrl;
          _isLoading = false;
        });
        if (widget.onImageSelected != null) {
          widget.onImageSelected!(downloadUrl);
        }
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        print('Error uploading image: $e');
      }
    }
  }

  Future<String> _uploadToFirebaseStorage(Uint8List imageData) async {
    String fileName = 'image_${DateTime.now().millisecondsSinceEpoch}.png';
    Reference storageRef =
        FirebaseStorage.instance.ref().child('public/$fileName');
    UploadTask uploadTask = storageRef.putData(imageData);

    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  @override
  void initState() {
    super.initState();
    if (widget.link != null && widget.link != '') {
      _link = widget.link;
    }
  }

  void _clearImage() {
    setState(() {
      _imageData = null;
      _link = null;
      widget.onImageSelected?.call('');
    });
  }

  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    Widget content;

    if (_isLoading) {
      content = QWidgets().progressIndicator;
    } else if (_imageData != null || _link != null) {
      content = Image.network(
        _link ?? '',
        height: 60,
        width: 80,
        fit: BoxFit.cover,
      );
    } else {
      // If no image data or link, show only the icon with optional text
      content = Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            widget.icon,
            color: QColors.primaryColor,
          ),
          if (widget.text.isNotEmpty)
            QText(
              text: widget.text,
              textAlign: TextAlign.center,
            ),
        ],
      );
    }

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: _imgFromGallery,
        child: _imageData != null || _link != null
            ? Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: _hovered
                      ? QColors.accentColorOpacity.withOpacity(0.1)
                      : null,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: content,
                ),
              )
            : content,
      ),
    );
  }
}
