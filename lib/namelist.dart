import 'package:flutter/material.dart';
import 'package:coffee/profile.dart';

class Profiles extends StatelessWidget {
  const Profiles({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Member'),
        backgroundColor: Colors.black,
      ),
      body: Column(
        children: [
          SizedBox(height: 30),
          Text(
            'Kelompok 24',
            style: TextStyle(
                fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          EachProfile(
            nama: "Ade Ilham",
            nim: "21120111930091",
          ),
          EachProfile(
            nama: "Mudzik Al Fahri",
            nim: "21120111930100",
          ),
          EachProfile(
            nama: "Rasyad Akmal",
            nim: "21120111930101",
          ),
          EachProfile(
            nama: "Maki Adnin",
            nim: "21120111940146",
          )
        ],
      ),
    );
  }
}
