import 'package:flutter/material.dart';
import 'package:rest_api_login_xp/api.dart';
import 'package:rest_api_login_xp/constants.dart';
import 'package:rest_api_login_xp/home_page.dart';
import 'package:rest_api_login_xp/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Landing extends StatefulWidget {
  const Landing({Key? key}) : super(key: key);

  @override
  _LandingState createState() => _LandingState();
}

class _LandingState extends State<Landing> {

  String _token = '';

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
  }

  void _loadCurrentUser() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    _token = (sharedPreferences.getString(kTokenKey) ?? '');
    if (_token == '') {
      /// No token locally stored
      /// Go to Login Page
      print('Case 1');
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => LoginPage()), (route) => false);
    } else {
      /// A token is stored
      print('A token is stored');
      print(_token);
      try {
        await Api().getCurrentUser();
        // await Api().refreshToken();
        /// Go to Home
        print('Case 2');
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => HomePage()), (route) => false);
      } catch (error) {
        print('error loadCurrent user');
        /// Go to login
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => LoginPage()), (route) => false);
      }
    }


  }

  @override
  Widget build(BuildContext context) {
    return Container(child: Center(child: CircularProgressIndicator(),),);
  }
}
