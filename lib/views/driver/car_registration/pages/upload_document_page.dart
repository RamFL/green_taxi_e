import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class UploadDocumentPage extends StatefulWidget {
  const UploadDocumentPage({Key? key, required this.onSelectedImage})
      : super(key: key);

  final Function onSelectedImage;

  @override
  State<UploadDocumentPage> createState() => _UploadDocumentPageState();
}

class _UploadDocumentPageState extends State<UploadDocumentPage> {
  File? selectedImage;
  final ImagePicker _picker = ImagePicker();

  getImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source);
    if (image != null) {
      selectedImage = File(image.path);
      widget.onSelectedImage(selectedImage);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          'Upload Documents',
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black),
        ),
        const SizedBox(
          height: 30,
        ),
        GestureDetector(
          onTap: () {
            getImage(ImageSource.camera);
          },
          child: Container(
            width: Get.width,
            height: Get.height * 0.25,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Color(0xffE3E3E3).withOpacity(0.4),
              border: Border.all(
                color: Color(0xff2FB654).withOpacity(0.26),
                width: 1,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.cloud_upload,
                  size: 40,
                  color: Color(0xff7D7D7D),
                ),
                Text(
                  selectedImage == null
                      ? 'Tap here to upload '
                      : 'Document is selected.',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xff7D7D7D),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
