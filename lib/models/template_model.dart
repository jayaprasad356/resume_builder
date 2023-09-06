import 'package:flutter_cvmaker/models/template_category_model.dart';

class TemplateModel {
  TemplateCategory category;
  String name;
  String fileJson;
  String thumb;

  TemplateModel({
    required this.category,
    required this.name,
    required this.fileJson,
    required this.thumb,
  });
}
