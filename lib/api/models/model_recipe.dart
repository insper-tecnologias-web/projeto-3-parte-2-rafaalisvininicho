class ModelRecipe {
  final String id;
  final String title;
  final String url;
  final String imageUrl;
  final String ingredients;
  final String preparationSteps;
  final double calorie;
  final double protein;
  final double fat;
  final double carbs;
  final DateTime consumedAt;
  final bool wasConsumed;
  final String mealType;

  ModelRecipe({
    required this.id,
    required this.title,
    required this.url,
    required this.imageUrl,
    required this.ingredients,
    required this.preparationSteps,
    required this.calorie,
    required this.protein,
    required this.fat,
    required this.carbs,
    required this.consumedAt,
    required this.wasConsumed,
    required this.mealType,
  });

  factory ModelRecipe.fromJson(Map<String, dynamic> json) {
    return ModelRecipe(
      id: json['id'],
      title: json['title'],
      url: json['url'],
      imageUrl: json['image_url'],
      ingredients: json['ingredients'],
      preparationSteps: json['preparation_steps'],
      calorie: json['calorie'],
      protein: json['protein'],
      fat: json['fat'],
      carbs: json['carbs'],
      consumedAt: DateTime.parse(json['consumed_at']),
      wasConsumed: json['was_consumed'],
      mealType: json['meal_type'],
    );
  }

    Map<String, dynamic> toJson() {
    return{
      'title': title,
      'url': url,
      'image_url': imageUrl,
      'ingredients': ingredients,
      'preparation_steps': preparationSteps,
      'calorie': calorie,
      'protein': protein,
      'fat': fat,
      'carbs': carbs,
      'consumed_at': consumedAt,
      'was_consumed': wasConsumed,
      'meal_type': mealType,
    };
  }
}