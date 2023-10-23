import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:loginapp/screens/detail_mangan.dart';

class ItemTruyenMoi extends StatelessWidget {
  final String id;
  final String image;
  final String name;
  final String sochap;

  ItemTruyenMoi(
      {super.key,
      required this.id,
      required this.image,
      required this.name,
      required this.sochap});

  @override
  Widget build(BuildContext context) {
    final widthS = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: SizedBox(
        // height: widthS * 6 / 8,
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    MangaDetailScreen(mangaId: id, storyName: name),
              ),
            );
          },
          child: Column(
            children: [
              ClipRRect(
                
                borderRadius:
                    BorderRadius.circular(20),
                child: Image.memory(base64Decode(image),height: 155, fit: BoxFit.cover),
              ),
              Column(
                children: [
                  Text(name,
                      style: TextStyle(fontSize: 15),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                  Text(sochap)
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
