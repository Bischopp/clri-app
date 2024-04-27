// import 'dart:async';
// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:project/navbar.dart';
// import 'package:aws_client/lambda_2014_11_11.dart';
// import 'package:aws_client/api_gateway_2015_07_09.dart';
//
// final lambda = Lambda(
//   region: 'ap-south-1', // e.g., 'us-east-1'
//   credentials: AwsClientCredentials(
//     accessKey: 'AKIA5FTY6KG4HOTPVS6K',
//     secretKey: 'CwaJlRvDJcLhIrj2GD1+j/Kx51uWvboLzB/M+l/k',
//   ),
// );
//
// class Home extends StatefulWidget {
//   const Home({Key? key}) : super(key: key);
//
//   @override
//   State<Home> createState() => _HomeState();
// }
//
// class _HomeState extends State<Home> {
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       drawer: NavBar(),
//       appBar: AppBar(
//         title: const Text('Unverified yet'),
//         centerTitle: true,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(10.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Row(
//               children: [
//                 Expanded(
//                   child: ElevatedButton(
//                     onPressed: () => getVerified(),
//                     child: const Text('Get verified',
//                         style: TextStyle(fontSize: 20)),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Future<void> getVerified() async {
//     try {
//       final response = await lambda.invoke(
//           functionName: 'YOUR_LAMBDA_FUNCTION_NAME',
//         invocationType: InvocationType.requestResponse, // or InvocationType.event
//         payload: 'YOUR_PAYLOAD', // Optional: JSON string payload
//       );
//       // Handle response
//       print('Response: ${response.payload}');
//     } catch (e) {
//       print('Error: $e');
//     }
//   }
//
//
//
//
//
//
// }
