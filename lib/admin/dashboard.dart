import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:amplify_authenticator/amplify_authenticator.dart';
import 'package:amplify_authenticator/amplify_authenticator.dart';
import 'package:project/homepage.dart';
import 'dart:developer';


class UserTablePage extends StatefulWidget {
  @override
  _UserTablePageState createState() => _UserTablePageState();
}

class _UserTablePageState extends State<UserTablePage> {
  List<Map<String, dynamic>> userData = [
    {'name': 'John Doe', 'email': 'john123@gmail.com'},
    {'name': 'Jane Smith', 'email': 'jane123@gmail.com'},
    {'name': 'Alice Johnson', 'email': 'alice132@gmail.com'},
    {'name': 'Bob Brown', 'email': 'bob344@gmail.com'},
    {'name': 'Eve Wilson', 'email': 'evewe23442@gmail.com'},
  ];



  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  void verifyUser(Map<String, dynamic> user) {
    // Implement verification logic here
    print('Verifying user: ${user['name']} (${user['email']})');
    // You can perform any actions you need here, such as making API calls, updating UI, etc.
  }

  Future<JsonWebToken?> getAccessToken() async {
    try {
      // final session = await Amplify.Auth.fetchAuthSession();
      final session = await Amplify.Auth.fetchAuthSession() as CognitoAuthSession;
      final idToken = session.userPoolTokensResult.value.idToken;
      return idToken;
    } catch (e) {
      print('Error getting access token: $e');
      return null;
    }
  }

  Future<void> _fetchUserData() async {
    try {
      const newApi  = 'https://ia4uuqb2pe.execute-api.ap-south-1.amazonaws.com/dev';
      const path = "/queries/listUsers";
      const apiName = "AdminQ";
      // final claims = {
      //   "cognito:groups": "admin",
      //   "email": "nadkarnivatsal@gmail.com"
      // };
      // final claimsJson = json.encode(claims);
      // final query = {
      //   "cognito:groups": "admin",
      //   "email": "nadkarnivatsal@gmail.com"
      // };
      final session = await Amplify.Auth.fetchAuthSession() as CognitoAuthSession;
      final accessToken = session.userPoolTokensResult.value.accessToken;
      final accessTokenValue = json.encode(accessToken);
      // final accessTokenValue = accessToken.toString();

      log(accessTokenValue);


      final header = {
        'authorizationToken': accessTokenValue,
      };
      final restOperation = Amplify.API.get(
        path,
        headers: (header),
        // queryParameters: query,
        apiName: apiName,
      );
      final response = await restOperation.response;

      // Process the response and populate userData list
      safePrint(response.body);
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Data'),
      ),
      body: userData.isEmpty
          ? Center(
        child: CircularProgressIndicator(),
      )
          : ListView.builder(
        itemCount: userData.length,
        itemBuilder: (context, index) {
          final user = userData[index];
          return ListTile(
            title: Text(user['name']),
            subtitle: Text(user['email']),
            trailing: ElevatedButton(
              onPressed: () {
                // Handle verify user button press
                verifyUser(user);
              },
              child: Text('Verify User'),
            ),
          );
        },
      ),

    );
  }
}
