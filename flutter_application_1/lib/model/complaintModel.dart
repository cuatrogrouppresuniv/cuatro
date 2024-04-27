
class Complaint {
  final String id;
  final String id_user;
  final String location;
  final String description;
  final String status;

  Complaint({
    required this.id,
    required this.id_user,
    required this.location,
    required this.description,
    required this.status,
  });

  factory Complaint.fromSnapshot(String id, Map<dynamic, dynamic> snapshot) {
    return Complaint(
      id: id,
      id_user: snapshot['id_user'],
      location: snapshot['location'],
      description: snapshot['description'],
      status: snapshot['status'],
    );
  }
}
