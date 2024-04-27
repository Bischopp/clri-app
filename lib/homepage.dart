import 'dart:async';
import 'dart:io';


import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:image/image.dart' as img;
import 'package:camera/camera.dart';
import 'package:project/navbar.dart';
import 'package:project/camera_page.dart';
import 'package:project/camera_page2.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';

Future<void> fetchCurrentUserAttributes() async {
  try {
    final result = await Amplify.Auth.fetchUserAttributes();
    for (final element in result) {
      safePrint('key: ${element.userAttributeKey}; value: ${element.value}');
    }
  } on AuthException catch (e) {
    safePrint('Error fetching user attributes: ${e.message}');
  }
}
class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  File? imageFile;
  File? imageFile2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavBar(),
      appBar: AppBar(
        title: const Text('Capturing Images'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => getImage(source: ImageSource.camera),
                    child: const Text('Capture Grain',
                        style: TextStyle(fontSize: 15)),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => getImage2(source: ImageSource.camera),
                    child: const Text('Capture Cross Section',
                        style: TextStyle(fontSize: 15),
                    textAlign: TextAlign.center,),
                  ),
                ),

              ],
            ),

          ],
        ),
      ),
    );
  }


  Future<void> getImage({required ImageSource source}) async {
    final permissionStatus = true;
    if (permissionStatus) {
      final camera = await availableCameras();
      final firstCamera = camera.first;
      /*var file =*/
      await Navigator.push(
        this.context,
        MaterialPageRoute(
          builder: (context) => CameraPage(camera: firstCamera),
        ),
      );
    } else {
      print('Camera permission denied');
    }
  }

  Future<void> getImage2({required ImageSource source}) async {
    final permissionStatus = true;
    if (permissionStatus) {
      final camera = await availableCameras();
      final firstCamera = camera.first;

      /*var file = */
      await Navigator.push(
        this.context,
        MaterialPageRoute(
          builder: (context) => CameraPage2(camera: firstCamera),
        ),
      );

    } else {
      print('Camera permission denied');
    }
  }

  Future<void> saveImagesToGallery() async {
    if (imageFile2 != null && imageFile != null) {
      try {
        // Save the first image (_imagePath) to gallery
        await GallerySaver.saveImage(imageFile2!.path, albumName: "cross");

        // Save the second image (imageFile) to gallery
        await GallerySaver.saveImage(imageFile!.path, albumName: "grain");

        print('Images saved to gallery successfully.');
      } catch (e) {
        print('Error saving images: $e');
      }
    } else {
      print('One or both images are null. Cannot save to gallery.');
    }
  }


  Future<File> processImage(XFile imageFile) async {
    final rawImage = await imageFile.readAsBytes();
    final img.Image? image = img.decodeImage(rawImage);

    if (image != null) {
      // Apply edge detection to the image using a custom algorithm or any other package.
      // For this example, we'll just return the original image without processing.
      return File(imageFile.path);
    } else {
      throw Exception('Failed to process image.');
    }
  }
}
