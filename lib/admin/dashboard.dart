import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class UserTablePage extends StatefulWidget {
  @override
  _UserTablePageState createState() => _UserTablePageState();
}

class _UserTablePageState extends State<UserTablePage> {
  List<Map<String, dynamic>> userData = [];

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<dynamic> listUsers(int limit) async {
    final String apiName = 'AdminQueries';
    final String path = '/listUsersInGroup';
    final Map<String, dynamic> queryStringParameters = {
      "groupname": "Editors",
      "limit": limit.toString(),
    };
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      // 'Authorization': (await fetchAuthSession())['tokens']['accessToken']['payload'],
    };
    final Uri uri = Uri.https('<your-api-id>.execute-api.<region>.amazonaws.com', '/<stage>/$path', queryStringParameters);

    final http.Response response = await http.get(uri, headers: headers);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to list editors: ${response.reasonPhrase}');
    }
  }

  // Future<Map<String, dynamic>> fetchAuthSession() async {
  //   // Implement your function to fetch the authentication session
  //   // This function should return a Map<String, dynamic> containing the tokens
  //   dynamic session = await Amplify.Auth.fetchAuthSession();
  //   session = await Amplify.Auth.fetchAuthSession(options: const FetchAuthSessionOptions(forceRefresh: true));
  //   final result = await Amplify.Auth.fetchAuthSession(
  //       options: FetchAuthSessionOptions(getAWSCredentials: true));
  //   final cognitoAuthSession = (result as CognitoAuthSession);
  //   return cognitoAuthSession.userPoolTokens?.idToken;
  //
  // }
  Future<void> _fetchUserData() async {
    try {
      // Check if the current user is an admin

      // const apiUrl = "https://p9kfas6qo5.execute-api.ap-south-1.amazonaws.com/test/AdminQueries188471e7-dev";
      // final payload = {
      //   "methodArn": "arn:aws:execute-api:ap-south-1:905418002872:p9kfas6qo5/*/GET/AdminQueries188471e7-dev",
      //   "resource": "/listUsers",
      //   "path": "/listUsers",
      //   "httpMethod": "GET",
      //   "queryStringParameters": {
      //     "cognito:groups": "admin",
      //   },
      //
      // };

      const newApi  = 'https://ia4uuqb2pe.execute-api.ap-south-1.amazonaws.com/dev';
      const path = "/queries/listUsers";
      const apiName = "AdminQ";
      final claims = {
        "cognito:groups": "admin",
        "email": "nadkarnivatsal@gmail.com"
      };
      final claimsJson = json.encode(claims);
      final query = {
        "cognito:groups": "admin",
        "email": "nadkarnivatsal@gmail.com",
        // Include claims information as a JSON string

      };
      final header = {
        'claims': claimsJson
      };

      // final header = {"claims": "" };
      final restOperation = Amplify.API.get(
        path,
        headers: header,
        queryParameters: query,
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
          );
        },
      ),
    );
  }
}
