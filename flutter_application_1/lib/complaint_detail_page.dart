import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_application_1/home_page.dart';
import 'package:flutter_application_1/model/complaintModel.dart';
import 'package:flutter_application_1/model/userModel.dart';

class ComplaintDetailPage extends StatelessWidget {
  final Complaint complaint;
  final User user;

  ComplaintDetailPage({required this.user,required this.complaint});

  void deleteComplaint(BuildContext context) {
    final databaseRef = FirebaseDatabase(databaseURL: "https://tps-project-app-default-rtdb.firebaseio.com/").ref().child('complaints');
    databaseRef.child(complaint.id).remove().then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Complaint deleted successfully'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomePage(user: user)),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete complaint: $error'),
          backgroundColor: Colors.red,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Complaint Detail'),
        backgroundColor: Color(0xFF436a95), // Warna latar belakang AppBar
      ),
      body: 
        Container(
          color: Color(0xFFF7EFEA), // Atur warna latar belakang sesuai kebutuhan
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Location: ${complaint.location}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text('Description: ${complaint.description}'),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => deleteComplaint(context),
                child: Text('Delete Complaint'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              ),
            ],
          ),
        ),
    );
  }
}
