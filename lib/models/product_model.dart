class ProductModel {
  final int id;
  final String title;
  final double price;
  final double discountPercentage;
  final int stock;
  final String thumbnail;
  final double rating;
  final String description;
  final List<String> images;
  final String category;

  ProductModel({
    required this.id,
    required this.title,
    required this.price,
    required this.discountPercentage,
    required this.stock,
    required this.thumbnail,
    required this.rating,
    required this.description,
    required this.images,
    required this.category,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      discountPercentage: (json['discountPercentage'] as num?)?.toDouble() ?? 0.0,
      stock: json['stock'] ?? 0,
      thumbnail: json['thumbnail'] ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      description: json['description'] ?? '',
      images: json['images'] != null 
          ? List<String>.from(json['images']) 
          : [],
      category: json['category'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'price': price,
      'discountPercentage': discountPercentage,
      'stock': stock,
      'thumbnail': thumbnail,
      'rating': rating,
      'description': description,
      'images': images,
      'category': category,
    };
  }
}