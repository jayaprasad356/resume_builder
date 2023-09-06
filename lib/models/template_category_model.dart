enum TemplateCategory {
  square,
  horizontal,
  vertical,
  panoramic,
}

class TemplateCategoryModel {
  String name;
  TemplateCategory category;

  TemplateCategoryModel({
    required this.name,
    required this.category,
  });
}
