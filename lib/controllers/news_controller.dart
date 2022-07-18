import 'package:berita_pendek/models/article_model.dart';
import 'package:berita_pendek/models/news_model.dart';
import 'package:flutter/material.dart';
// import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class NewsController extends GetxController {
  List<Article> news = <Article>[];
  ScrollController scrollController = ScrollController();
  RxBool notFound = false.obs;
  RxBool isLoading = false.obs;
  RxString cName = ''.obs;
  RxString country = ''.obs;
  RxString category = ''.obs;
  RxString findNews = ''.obs;
  RxInt pageNum = 1.obs;
  dynamic isSwitched = false.obs;
  dynamic isPageLoading = false.obs;
  RxInt pageSize = 10.obs;
  String baseApi = "https://newsapi.org/v2/top-headlines?";

  @override
  void onInit() {
    scrollController = new ScrollController()..addListener(_scrollListener);
    getNews();
    super.onInit();
  }

  _scrollListener() {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      isLoading.value = true;
    }
  }

  getNews({channel = '', searchKey = '', reload = false}) async {
    notFound.value = false;

    if (!reload && isLoading.value == false) {
    } else {
      country.value = '';
      category.value = '';
    }

    if (isLoading == true) {
      pageNum++;
    } else {
      news = [];
      pageNum.value = 1;
    }

    baseApi = "https://newsapi.org/v2/top-headlines?pageSize=10&page=$pageNum&";
    baseApi += country == '' ? 'country=id&' : 'country=$country&';
    baseApi += category == '' ? '' : 'category=$category&';
    baseApi += 'apikey=e9d14be976ca488abc300e6db155d455';

    if (channel != '') {
      country.value = '';
      category.value = '';

      baseApi =
          "https://newsapi.org/v2/top-headlines?pageSize=10&page=$pageNum&sources=$channel&apikey=e9d14be976ca488abc300e6db155d455";
    }

    if (searchKey != '') {
      country.value = '';
      category.value = '';

      baseApi =
          "https://newsapi.org/v2/top-headlines?pageSize=10&page=$pageNum&q=$searchKey&apikey=e9d14be976ca488abc300e6db155d455";
    }
    print(baseApi);
    getDataFromApi(baseApi);
  }

  getDataFromApi(url) async {
    http.Response res = await http.get(Uri.parse(url));

    if (res.statusCode == 200) {
      NewsModel newsData = NewsModel.newsFromJson(res.body);

      if (newsData.articles.length == 0 && newsData.totalResults == 0) {
        notFound.value = isLoading.value == true ? false : true;
        isLoading.value = false;
        update();
      } else {
        if (isLoading.value == true) {
          news = [...news, ...newsData.articles];
          update();
        } else {
          if (newsData.articles.length != 0) {
            news = newsData.articles;
            if (scrollController.hasClients) scrollController.jumpTo(0.0);
            update();
          }
        }
        notFound.value = false;
        isLoading.value = false;
        update();
      }
    } else {
      notFound.value = false;
      update();
    }
  }

  changeTheme(value) {
    Get.changeTheme(value == true ? ThemeData.dark() : ThemeData.light());
    isSwitched = value;
    update();
  }
}
