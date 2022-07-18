import 'package:json_annotation/json_annotation.dart';
import 'source_model.dart';

part 'article_model.g.dart';

@JsonSerializable(explicitToJson: true)
class Article {
  String? author, description, urlToImage, content;
  String title, url, publishedAt;
  Source source;

  Article(
    this.source,
    this.author,
    this.title,
    this.description,
    this.url,
    this.urlToImage,
    this.publishedAt,
    this.content,
  );

  factory Article.fromJson(Map<String, dynamic> json) =>
      _$ArticleFromJson(json);
  Map<String, dynamic> toJson() => _$ArticleToJson(this);
}