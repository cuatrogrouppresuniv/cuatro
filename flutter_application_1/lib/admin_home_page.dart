import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_application_1/add_complaint_page.dart';
import 'package:flutter_application_1/admin_detail_page.dart';
import 'package:flutter_application_1/complaint_detail_page.dart';
import 'package:flutter_application_1/login_page.dart';
import 'package:flutter_application_1/model/complaintModel.dart';
import 'package:flutter_application_1/model/userModel.dart';



class AdminHomePage extends StatelessWidget {
  final User user;

  AdminHomePage({required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
        backgroundColor: Color(0xFF436a95), // Warna latar belakang AppBar        
        actions: [
          PopupMenuButton(
            itemBuilder: (BuildContext context) => [
              PopupMenuItem(
                child: Text('Logout'),
                value: 'logout',
              ),
            ],
            onSelected: (value) {
              if (value == 'logout') {
                _logout(context);
              }
            },
          ),
        ],
      ),
      body: Container(
        color: Color(0xFFF7EFEA), // Atur warna latar belakang sesuai kebutuhan
        child: ComplaintList(user: user),
      ),
    );
  }
}


  Future<void> _logout(BuildContext context) async {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

class ComplaintList extends StatefulWidget {
  final User user;

  ComplaintList({required this.user});

  @override
  _ComplaintListState createState() => _ComplaintListState();
}

class _ComplaintListState extends State<ComplaintList> {
  late List<Complaint> complaints;

  @override
  void initState() {
    super.initState();
    complaints = [];
    fetchComplaints();
    
    print(complaints);
  }

  @override
  void dispose() {
    // Membersihkan daftar komplain saat widget di dispose
    complaints.clear();
    super.dispose();
  }

  Future<void> fetchComplaints() async {
    final databaseRef = FirebaseDatabase(databaseURL: "https://tps-project-app-default-rtdb.firebaseio.com/").ref().child('complaints');

    List<Complaint> fetchedComplaints = []; // Inisialisasi daftar complaints
    await databaseRef.onValue.listen((data) { 
      if (data.snapshot.value != null) {
        Map<String, dynamic> values = data.snapshot.value as Map<String, dynamic>;
        values.forEach((key, value) {
          int i=0;
          String ids="";
          String id_users="";
          String locations="";
          String descriptions="";
          String statuss="";
          ids = key; 
          value.forEach((key, p) {
            if(i==0){
              descriptions = p;
            }
            else if(i==1){
              locations = p;
            }
            else if(i==2){
              statuss = p;
            }
            else{
              id_users = p;
            }
            i++;
          });
          Complaint data = Complaint(
                          id: ids,
                          id_user: id_users,
                          location: locations,
                          description: descriptions,
                          status: statuss,
                        );
          fetchedComplaints.add(data);
        });

        setState(() {
        complaints = fetchedComplaints;
      });
      }
    });
    


  }

  @override
  Widget build(BuildContext context) {
    if (complaints == null) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else if (complaints.isEmpty) {
      return Center(
        child: Text(
          'No complaints found',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey),
        ),
      );
    } else {
      return ListView.builder(
        itemCount: complaints.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Card(
              elevation: 3,
              child: ListTile(
                leading: Icon(Icons.file_copy, color: Colors.grey),
                title: Text(complaints[index].location),
                onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AdminDetailPage(user: widget.user,complaint: complaints[index])),
                    );
                },
              ),
            ),
          );
        },
      );
    }
  }

}
