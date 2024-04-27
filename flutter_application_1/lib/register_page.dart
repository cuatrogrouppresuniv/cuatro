import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_application_1/login_page.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Users {
  final String name;
  final String email;
  final String password;

  Users({required this.name, required this.email, required this.password});

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'password': password,
    };
  }
}

class RegisterPage extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  createUserInFirebase(BuildContext context, Users user) async {
    // ignore: deprecated_member_use
    final databaseRefs = FirebaseDatabase(databaseURL: "https://tps-project-app-default-rtdb.firebaseio.com/").ref().child('users');
    final data = await databaseRefs.orderByChild('email').equalTo(user.email).once();
    if (data.snapshot.value != null) {
        Fluttertoast.showToast(
          msg: "Email Already Taken",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
    }
    else{
      final databaseRef = FirebaseDatabase(databaseURL: "https://tps-project-app-default-rtdb.firebaseio.com/").reference();
      await databaseRef.child('users').push().set({
        "username" : user.name,
        "email" : user.email,
        "password" : user.password,
      });
      Fluttertoast.showToast(
        msg: "Registration Success",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    }
    
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
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
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    filled: true,
                    fillColor: Colors.white, // Warna latar belakang input
                  ),
                ),
                SizedBox(height: 20.0),
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
                    // Membuat objek User dari data input
                    Users user = Users(
                      name: nameController.text,
                      email: emailController.text,
                      password: passwordController.text,
                    );
                    // Menyimpan pengguna ke Firebase Realtime Database
                    createUserInFirebase(context,user);
                    
                    // Navigasi ke halaman selanjutnya, atau lakukan yang sesuai dengan aplikasi Anda
                    
                    
                  },
                  child: Text('Create Account'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
