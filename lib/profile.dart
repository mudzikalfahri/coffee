import 'package:flutter/material.dart';

class EachProfile extends StatelessWidget {
  final String nama;
  final String nim;
  const EachProfile({
    Key? key,
    required this.nama,
    required this.nim,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          Container(
              height: 60,
              width: 60,
              margin: EdgeInsets.all(5.0),
              decoration:
                  BoxDecoration(color: Colors.black, shape: BoxShape.circle),
              child: Center(
                child: Text(
                  nama[0].toUpperCase(),
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              )),
          Text(nama),
          Text(nim)
        ],
      ),
    );
  }
}
