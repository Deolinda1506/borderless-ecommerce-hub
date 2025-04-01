class Category {
  final String id;
  final String name;
  final String imageUrl;
  final List<SubCategory>? subCategories;

  Category({
    required this.id,
    required this.name,
    required this.imageUrl,
    this.subCategories,
  });
}

class SubCategory {
  final String id;
  final String name;
  final String image;

  SubCategory({
    required this.id,
    required this.name,
    required this.image,
  });
}
