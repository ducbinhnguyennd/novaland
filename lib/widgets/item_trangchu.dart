import 'package:flutter/material.dart';
import 'package:loginapp/getapi/trangchuapi.dart';
import 'package:loginapp/model/trangchu_model.dart';
import 'package:loginapp/screens/detail_category_screen.dart';
import 'package:loginapp/widgets/item_truyenmoi.dart';

class ItemTrangChu extends StatefulWidget {
  const ItemTrangChu({Key? key});

  @override
  State<ItemTrangChu> createState() => _ItemTrangChuState();
}

class _ItemTrangChuState extends State<ItemTrangChu> {
  late Future<List<Manga>> mangaList;

  @override
  void initState() {
    super.initState();
    mangaList = MangaService.fetchMangaList();
  }

  Map<String, List<Manga>> groupMangasByCategory(List<Manga> mangas) {
    Map<String, List<Manga>> groupedMangas = {};
    for (var manga in mangas) {
      if (!groupedMangas.containsKey(manga.category)) {
        groupedMangas[manga.category] = [];
      }
      groupedMangas[manga.category]!.add(manga);
    }
    return groupedMangas;
  }

  @override
  Widget build(BuildContext context) {
    final widthS = MediaQuery.of(context).size.width;
    return FutureBuilder<List<Manga>>(
      future: mangaList,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Đã xảy ra lỗi: ${snapshot.error}');
        } else {
          if (snapshot.hasData) {
            List<Manga> mangas = snapshot.data!;
            Map<String, List<Manga>> groupedMangas =
                groupMangasByCategory(mangas);

            return Column(
              children: groupedMangas.entries.map((entry) {
                final category = entry.key;
                final categoryMangas = entry.value;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => CategoryDetailScreen(
                                categoryMangas: categoryMangas,
                                categoryName: category,
                              ),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Thể loại ${category}',
                                  style: TextStyle(
                                      fontSize: 18, fontWeight: FontWeight.bold)),
                                      Text('Xem thêm')
                            
                            ],
                          ),
                        )),
                    // GridView(
                    //   // scrollDirection: Axis.horizontal,
                    //   gridDelegate:
                    //       const SliverGridDelegateWithFixedCrossAxisCount(
                    //     crossAxisCount: 1,
                        
                    //     // crossAxisSpacing: 10,
                    //     mainAxisSpacing: 10,
                    //     childAspectRatio: 2 / 4,
                    //   ),
                    //   shrinkWrap: true,
                    //   physics: const NeverScrollableScrollPhysics(),
                    //   itemCount:
                    //       categoryMangas.length > 3 ? 3 : categoryMangas.length,
                    //   itemBuilder: (context, index) {
                    //     return ItemTruyenMoi(
                    //       id: categoryMangas[index].id,
                    //       name: categoryMangas[index].mangaName,
                    //       image: categoryMangas[index].image,
                    //       sochap:
                    //           categoryMangas[index].totalChapters.toString(),
                    //     );
                    //   },
                    // ),
                  SizedBox(
            width: double.infinity,
            // height: widthS / (Globals.isTablet ? 3 : 2),
            height: 220,
            child: GridView(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: widthS / 1,
                childAspectRatio: 2 / 1,
                crossAxisSpacing: 0,
                mainAxisSpacing: 0,
              ),
              children: List.generate(categoryMangas?.length ?? 0, (index) {
                return ItemTruyenMoi(
                          id: categoryMangas[index].id,
                          name: categoryMangas[index].mangaName,
                          image: categoryMangas[index].image,
                          sochap:
                              categoryMangas[index].totalChapters.toString(),
                        );
              }),
            ),
          )

                  ],
                );
              }).toList(),
            );
          } else {
            return Text('Không có dữ liệu.');
          }
        }
      },
    );
  }
}
