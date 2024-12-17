import 'package:flutter/material.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  

  @override
  Widget build(BuildContext context) {
    return  const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Affichage de l'image
              

                SizedBox(height: 100),
                Text(
                  'Users Screen',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                SizedBox(height: 100),

              

                ],
            );
   }
}