import 'package:berita_pendek/controllers/news_controller.dart';
import 'package:berita_pendek/models/utils.dart';
import 'package:berita_pendek/views/components/drop_down_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Drawer sideDrawer(NewsController newsController) {
  return Drawer(
    child: ListView(
      padding: EdgeInsets.symmetric(vertical: 60.0),
      children: <Widget>[
        Container(
          child: GetBuilder<NewsController>(
            builder: (controller) {
              return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    controller.cName != ''
                        ? Text("country = ${controller.cName.value}")
                        : Container(),
                    SizedBox(height: 10.0),
                    controller.category != ''
                        ? Text("country =  ${controller.category.value}")
                        : Container(),
                  ]);
            },
            init: NewsController(),
          ),
        ),
        Container(
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: 5.0),
                  child: TextFormField(
                    decoration:
                        InputDecoration(hintText: "Masukan Kata Kunci.."),
                    scrollPadding: EdgeInsets.all(5.0),
                    onChanged: (val) {
                      newsController.findNews.value = val;
                      newsController.update();
                    },
                  ),
                ),
              ),
              MaterialButton(
                  child: Text("Cari"),
                  onPressed: () async {
                    newsController.getNews(
                        searchKey: newsController.findNews.value);
                  })
            ],
          ),
        ),
        ExpansionTile(
          title: Text("Negara"),
          children: <Widget>[
            for (int i = 0; i < listOfCountry.length; i++)
              dropDownList(
                call: () {
                  newsController.country.value = listOfCountry[i]["code"]!;
                  newsController.cName.value =
                      listOfCountry[i]["name"]!.toUpperCase();
                  newsController.getNews();
                },
                name: listOfCountry[i]['name']!.toUpperCase(),
              ),
          ],
        ),
        ExpansionTile(
          title: Text("Kategori"),
          children: <Widget>[
            for (int i = 0; i < listOfCategory.length; i++)
              dropDownList(
                call: () {
                  newsController.country.value = listOfCategory[i]["code"]!;
                  newsController.getNews();
                },
                name: listOfCategory[i]['name']!.toUpperCase(),
              ),
          ],
        ),
        ExpansionTile(
          title: Text("Channel"),
          children: <Widget>[
            for (int i = 0; i < listOfNewsChannel.length; i++)
              dropDownList(
                call: () {
                  newsController.getNews(channel: listOfNewsChannel[i]["code"]);
                },
                name: listOfNewsChannel[i]['name']!.toUpperCase(),
              ),
          ],
        ),
        ListTile(
          title: Text("Tutup"),
          onTap: () => Get.back(),
        )
      ],
    ),
  );
}
