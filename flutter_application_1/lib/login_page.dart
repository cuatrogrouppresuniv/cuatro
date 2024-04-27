import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/admin_home_page.dart';
import 'package:flutter_application_1/home_page.dart';
import 'package:flutter_application_1/register_page.dart';
import 'package:flutter_application_1/model/userModel.dart';
import 'package:fluttertoast/fluttertoast.dart';



class LoginPage extends StatelessWidget {

  
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  signInWithEmailAndPassword(BuildContext context,String email, String password) async {
    if(email =="admin" && password=="admin"){
      
        User users = User(
          id: "0",
          name: "Admin",
          email: "admin",
          password: "admin",
        );
        Fluttertoast.showToast(
          msg: "Welcome "+users.name,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AdminHomePage(user: users)),
        );
    }
    else{
      final databaseRef = FirebaseDatabase(databaseURL: "https://tps-project-app-default-rtdb.firebaseio.com/").ref().child('users');

      final data = await databaseRef.orderByChild('email').equalTo(email).once();
      if (data.snapshot.value != null) {
        Map<String, dynamic> values = data.snapshot.value as Map<String, dynamic>;
        int ada = 0;

        values.forEach((key, value) {
          int i=0;
          String names ="";
          String emails ="";
          String passwords ="";
          String ids ="";
          ids = key;
          value.forEach((key, p) {
            if(i==0){
              emails = p;
            }
            else if(i==1){
              names = p;
            }
            else{
              passwords = p;
            }
            i++;
          });
          User users = User(
            id: ids,
            name: names,
            email: emails,
            password: passwords,
          );
          if (users.password == password) {
            ada = 1;
            Fluttertoast.showToast(
              msg: "Welcome "+users.name,
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.red,
              textColor: Colors.white,
            );
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomePage(user: users)),
            );
          }
        });
        if(ada==0){
          
            Fluttertoast.showToast(
              msg: "Incorrect Email or Password",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.red,
              textColor: Colors.white,
            );
        }
      }
      else{
        Fluttertoast.showToast(
          msg: "Incorrect Email or Password",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    }
      
  }
    
    
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
        backgroundColor: Color(0xFF436a95), // Warna latar belakang AppBar
      ),
      
      body: Container(
        color: Color(0xFFF7EFEA), // Warna latar belakang body
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    filled: true,
                    fillColor: Colors.white, // Warna latar belakang input
                  ),
                ),
                SizedBox(height: 20.0),
                TextField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    filled: true,
                    fillColor: Colors.white, // Warna latar belakang input
                  ),
                  obscureText: true,
                ),
                SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: () {
                    // Tambahkan fungsi untuk melakukan login
                    User user = signInWithEmailAndPassword(context,emailController.text,passwordController.text) as User;
                    
                    
                  },
                  child: Text('Login'),
                ),
                SizedBox(height: 10.0),
                TextButton(
                  onPressed: () {
                    // Navigasi ke halaman registrasi
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RegisterPage()),
                    );
                  },
                  child: Text('Create an Account'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
