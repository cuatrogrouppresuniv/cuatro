import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_application_1/admin_home_page.dart';
import 'package:flutter_application_1/home_page.dart';
import 'package:flutter_application_1/model/complaintModel.dart';
import 'package:flutter_application_1/model/userModel.dart';

class AdminDetailPage extends StatefulWidget {
  final Complaint complaint;
  final User user;

  AdminDetailPage({required this.user,required this.complaint});

  @override
  _AdminDetailPageState createState() => _AdminDetailPageState();
}

class _AdminDetailPageState extends State<AdminDetailPage> {
  String _currentStatus = "";

  @override
  void initState() {
    super.initState();
    _currentStatus = widget.complaint.status;
  }

  void updateStatus(String newStatus) {
    final databaseRef = FirebaseDatabase(databaseURL: "https://tps-project-app-default-rtdb.firebaseio.com/").ref().child('complaints');
    databaseRef.child(widget.complaint.id).update({'status': newStatus}).then((_) {
      setState(() {
        _currentStatus = newStatus;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Status updated successfully'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AdminHomePage(user: widget.user)),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update status: $error'),
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
      body: Container(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Location: ${widget.complaint.location}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text('Description: ${widget.complaint.description}'),
              SizedBox(height: 16),
              Text('Current Status: $_currentStatus'),
              SizedBox(height: 16),
              if (_currentStatus != 'Accepted')
              ElevatedButton(
                onPressed: () => updateStatus('Accepted'),
                child: Text('Accept'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
