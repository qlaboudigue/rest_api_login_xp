import 'package:flutter/material.dart';
import 'package:rest_api_login_xp/api.dart';
import 'package:rest_api_login_xp/home_page.dart';
class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  TextEditingController _mailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          padding: EdgeInsets.symmetric(
              horizontal: 16.0
          ),
          child: _isLoading
              ? Center(child: CircularProgressIndicator(),)
              : ListView(
            children: [
              headerSection(),
              textSection(),
              buttonSection(),
            ],
          )
      ),
    );
  }

  Widget headerSection() {
    return Container(
      child: Text('Rest Api authentication'),
    );
  }

  Widget textSection() {
    return Container(
      child: Column(
        children: [
          TextFormField(
            controller: _mailController,
            decoration: InputDecoration(
                labelText: 'Email'
            ),
          ),
          SizedBox(height: 30.0,),
          TextFormField(
            controller: _passwordController,
            decoration: InputDecoration(
                labelText: 'Password'
            ),
          ),
        ],
      ),
    );
  }

  Widget buttonSection() {
    return ElevatedButton(
        onPressed: (){
          setState(() {
            _isLoading = true;
          });
          try {
            Api().log(_mailController.text, _passwordController.text);
            print('Login ok');
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => HomePage()), (route) => false);
          } catch (error) {
            print('Error during login');
          }

        }, child: Text('Se connecter'));
  }




}