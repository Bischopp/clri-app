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

/*Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //await configureAmplify();
  runApp(const MaterialApp(
    home: Home(),
  ));
}*/

/*Future<void> configureAmplify() async {
  // Add your Amplify configuration here (e.g., Auth, API, Storage, etc.)
  try {
    await Amplify.addPlugins([AmplifyAuthCognito()]);
    await Amplify.configure(amplifyconfig);
    print('Amplify initialized successfully');
  } catch (e) {
    print('Failed to initialize Amplify: $e');
  }
}*/

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
                        style: TextStyle(fontSize: 18)),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => getImage2(source: ImageSource.camera),
                    child: const Text('Capture Cross Section',
                        style: TextStyle(fontSize: 18)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
/*
  void _takePhoto() async {
    ImagePicker.pickImage(source: ImageSource.camera)
        .then((File recordedImage) {
      if (recordedImage != null && recordedImage.path != null) {
        setState(() {
          //firstButtonText = 'saving in progress...';
        });
        GallerySaver.saveImage(recordedImage.path).then((String path) {
          setState(() {
            firstButtonText = 'image saved!';
          });
        });
      }
    });
  }
*/

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
      /*if (file != null) {
        setState(() {
          imageFile = File(file.path);
        });
      }*/
      /*if (imageFile2 != null && imageFile != null) {
        try {
          // Save the first image (_imagePath) to gallery
          await GallerySaver.saveImage(imageFile2!.path, albumName: "cross");

          // Save the second image (imageFile) to gallery
          await GallerySaver.saveImage(imageFile!.path, albumName: "grain");

          setState(() {
            imageFile = null;
          });
          setState(() {
            imageFile2 = null;
          });

          print('Images saved to gallery successfully.');
        } catch (e) {
          print('Error saving images: $e');
        }
      } else {
        print('One or both images are null. Cannot save to gallery.');
      }*/
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
      /*if (file != null) {
        setState(() {
          imageFile2 = File(file.path);
        });
      }
      if (imageFile2 != null && imageFile != null) {
        try {
          // Save the first image (_imagePath) to gallery
          await GallerySaver.saveImage(imageFile2!.path, albumName: "cross");

          // Save the second image (imageFile) to gallery
          await GallerySaver.saveImage(imageFile!.path, albumName: "grain");

          setState(() {
            imageFile = null;
          });
          setState(() {
            imageFile2 = null;
          });

          print('Images saved to gallery successfully.');
        } catch (e) {
          print('Error saving images: $e');
        }
      } else {
        print('One or both images are null. Cannot save to gallery.');
      }*/
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

  /*Future<void> getImageFromCamera() async {
    bool isCameraGranted = await Permission.camera.request().isGranted;
    if (!isCameraGranted) {
      isCameraGranted =
          await Permission.camera.request() == PermissionStatus.granted;
    }

    if (!isCameraGranted) {
      // Have not permission to camera
      return;
    }

    // Generate filepath for saving
    String imagePath = join((await getApplicationSupportDirectory()).path,
        "${(DateTime.now().millisecondsSinceEpoch / 1000).round()}.jpeg");

    try {
      //Make sure to await the call to detectEdge.
      bool success = await EdgeDetection.detectEdge(
        imagePath,
        canUseGallery: true,
        androidScanTitle: 'Scanning', // use custom localizations for android
        androidCropTitle: 'Crop',
        androidCropBlackWhiteTitle: 'Black White',
        androidCropReset: 'Reset',
      );
      print("success: $success");
    } catch (e) {
      print(e);
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _imagePath = imagePath;
    });
  }*/

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
