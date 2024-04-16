import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:image/image.dart' as img;
import 'package:camera/camera.dart';
import 'package:project/navbar.dart';
import 'package:project/camera_page_test.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

//import 'package:aws_common/vm.dart';

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

class Test extends StatefulWidget {
  const Test({Key? key}) : super(key: key);

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  File? imageFile;
  File? imageFile2;
  String responseResult = "abc";
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavBar(),
      appBar: AppBar(
        title: const Text('Capturing Images'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (responseResult != null)
                          Center(
                            child: Text(
                              responseResult!,
                              style: TextStyle(color: Colors.blue),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () =>
                                    getImage(source: ImageSource.camera),
                                child: const Text('Capture Grain',
                                    style: TextStyle(fontSize: 18)),
                              ),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () =>
                                    getImage2(source: ImageSource.camera),
                                child: const Text('Capture Cross Section',
                                    style: TextStyle(fontSize: 18)),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (responseResult == null)
            Container(
              color: Colors.black,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> uploadToS3(
      File file, String albumName, String t, String randomKey) async {
    try {
      setState(() {
        _isProcessing = true;
      });
      String apiUrl;
      if (albumName == 'cross') {
        apiUrl =
            'https://6hc9oev3j1.execute-api.ap-south-1.amazonaws.com/v0/img_post';
      } else {
        apiUrl =
            'https://6hc9oev3j1.execute-api.ap-south-1.amazonaws.com/v0/img_post';
      }

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/jpg',
          'x-api-key': 'ZoQ9dQv9e54axJZwsQfAD5zLeXz7W9OJaM7uWbER',
          'rkey': randomKey,
          'key-date': t,
        },
        body: await file.readAsBytes(),
      );

      final jsonResponse = jsonDecode(response.body);
      final result = jsonResponse['body']['prediction'];
      setState(() {
        responseResult = result;
        _isProcessing = false;
      });

      print('Image uploaded to S3 successfully.');
      print('Error uploading image to S3. Status code: ${response.statusCode}');
    } catch (e) {
      print('Error uploading image to S3: $e');
    }
  }

  Future<void> getImage({required ImageSource source}) async {
    final permissionStatus = true;
    if (permissionStatus) {
      final camera = await availableCameras();
      final firstCamera = camera.first;
      var file = await Navigator.push(
        this.context,
        MaterialPageRoute(
          builder: (context) => CameraPageTest(camera: firstCamera),
        ),
      );
      if (file != null) {
        setState(() {
          imageFile = File(file.path);
        });
      }
      if (imageFile2 != null && imageFile != null) {
        try {
          String randomKey = (10000 + Random().nextInt(90000)).toString();

          DateTime now = DateTime.now();
          String formattedDate = DateFormat('yyyyMMdd_HHmmss_SSS').format(now);
          await uploadToS3(imageFile!, 'grain', formattedDate, randomKey);

          setState(() {
            imageFile = null;
          });
          setState(() {
            imageFile2 = null;
          });

          print('Images captured and uploaded to S3 successfully.');
        } catch (e) {
          print('Error capturing/uploading images: $e');
        }
      } else {
        print('One or both images are null. Cannot capture/upload to S3.');
      }
    } else {
      print('Camera permission denied');
    }
  }

  Future<void> getImage2({required ImageSource source}) async {
    final permissionStatus = true;
    if (permissionStatus) {
      final camera = await availableCameras();
      final firstCamera = camera.first;

      var file = await Navigator.push(
        this.context,
        MaterialPageRoute(
          builder: (context) => CameraPageTest(camera: firstCamera),
        ),
      );
      if (file != null) {
        setState(() {
          imageFile2 = File(file.path);
        });
      }
      if (imageFile2 != null && imageFile != null) {
        try {
          String randomKey = (10000 + Random().nextInt(90000)).toString();

          DateTime now = DateTime.now();
          String formattedDate = DateFormat('yyyyMMdd_HHmmss_SSS').format(now);
          //await uploadToS3(imageFile2!, 'cross', formattedDate, randomKey);
          await uploadToS3(imageFile!, 'grain', formattedDate, randomKey);

          setState(() {
            imageFile = null;
          });
          setState(() {
            imageFile2 = null;
          });

          print('Images captured and uploaded to S3 successfully.');
        } catch (e) {
          print('Error capturing/uploading images: $e');
        }
      } else {
        print('One or both images are null. Cannot capture/upload to S3.');
      }
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
}
