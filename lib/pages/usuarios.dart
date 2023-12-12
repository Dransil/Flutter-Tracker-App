import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UsersList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Usuarios')),
      ),
      backgroundColor: const Color.fromARGB(162, 7, 206, 159),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          }

          final users = snapshot.data!.docs;

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index].data() as Map<String, dynamic>;
              return UserCard(
                displayName: user['displayName'],
                photoURL: user['photoURL'],
              );
            },
          );
        },
      ),
    );
  }
}

class UserCard extends StatelessWidget {
  final Key? key;
  final String displayName;
  final String? photoURL;

  const UserCard({
    this.key,
    required this.displayName,
    this.photoURL,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          radius: 30,
          backgroundImage: photoURL != null ? NetworkImage(photoURL!) : null,
          backgroundColor: Colors.grey[300],
        ),
        title: Text(displayName),
        // Puedes agregar más detalles del usuario según sea necesario
      ),
    );
  }
}
