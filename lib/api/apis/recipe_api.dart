part of './../api_manager.dart';

extension RecipeApi on ApiManager {

  /// Get todas as receitas do backend
  Future<List<ModelRecipe>> getAllRecipes() async {
    final response = await get("recipes/data/");
    final List<ModelRecipe> recipes = [];
    for (final item in response) {
      recipes.add(ModelRecipe.fromJson(item));
    }
    return recipes;
  }

  /// Adiciona uma receita à lista de refeições do usuário
  Future<void> addRecipe(String recipeId) async {
    final userId = Hive.box('userData').get('id');
    await post("recipes/add/", {
      'user_id': userId,
      'recipe_id': recipeId,
    });
  }

  /// Marca uma receita como consumida
  Future<void> markAsConsumed(String recipeId) async {
    final userId = Hive.box('userData').get('id');
    await post("recipes/set/$recipeId/", {
      'user_id': userId,
    });
  }

  /// Obtém todas as refeições do usuário
  Future<List<ModelRecipe>> getUserMeals() async {
    final userId = Hive.box('userData').get('id');
    final response = await post("recipes/meals/", {
      'user_id': userId,
    });
    final List<ModelRecipe> meals = [];
    for (final item in response) {
      meals.add(ModelRecipe.fromJson(item));
    }
    return meals;
  }
}
