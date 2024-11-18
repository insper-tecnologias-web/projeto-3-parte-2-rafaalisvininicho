import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:projeto/widgets/pad_scaffold.dart';
import 'package:projeto/api/models/model_recipe.dart';
import 'package:projeto/api/api_manager.dart';
import 'package:projeto/widgets/recipe_item.dart';


class HealthyMenuPage extends StatefulWidget {
  const HealthyMenuPage({Key? key}) : super(key: key);

  @override
  State<HealthyMenuPage> createState() => _HealthyMenuPageState();
}

class _HealthyMenuPageState extends State<HealthyMenuPage> {
  List<ModelRecipe> _recipes = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchRecipes();
  }

  /// Obtém todas as receitas do backend
  Future<void> _fetchRecipes() async {
    try {
      final recipes = await ApiManager().getAllRecipes();
      setState(() {
        _recipes = recipes;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Erro ao carregar receitas: $e');
    }
  }

  /// Adiciona uma receita à lista de refeições do usuário
  Future<void> _addRecipe(String recipeId) async {
    try {
      await ApiManager().addRecipe(recipeId);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Receita adicionada com sucesso!')),
      );
    } catch (e) {
      print('Erro ao adicionar receita: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao adicionar receita.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return PadScaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _recipes.isEmpty
              ? const Center(child: Text('Nenhuma receita disponível.'))
              : ListView.builder(
                  itemCount: _recipes.length,
                  itemBuilder: (context, index) {
                    final recipe = _recipes[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                      child: RecipeItem(
                        recipe: recipe,
                        onAdd: () => _addRecipe(recipe.id),
                      ),
                    );
                  },
                ),
    );
  }
}