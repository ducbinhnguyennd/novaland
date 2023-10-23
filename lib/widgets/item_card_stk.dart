import 'package:flutter/material.dart';

class ItemCardStk extends StatelessWidget {
  const ItemCardStk(
      {super.key,
      required this.title,
      required this.onTap,
      required this.imagestk});
  final String title;
  final String imagestk;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {},
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(left: 10),
              // width: 100,
              height: 60,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(imagestk),
                  fit: BoxFit.contain,
                ),
                borderRadius: BorderRadius.all(Radius.circular(50)),
              ),
            ),
            Text(
              title,
              style: TextStyle(fontSize: 17),
            ),
            SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }
}
