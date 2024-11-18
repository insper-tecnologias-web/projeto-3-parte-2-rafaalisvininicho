import 'package:flutter/material.dart';
import 'package:projeto/api/models/model_recipe.dart';

class RecipeItem extends StatelessWidget {
  final ModelRecipe recipe; // Modelo passado diretamente para o item
  final VoidCallback onAdd; // Função para o botão de adicionar

  const RecipeItem({
    Key? key,
    required this.recipe,
    required this.onAdd,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
          ),
        ],
      ),
      padding: const EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Imagem da refeição
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.network(
              recipe.imageUrl,
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 16),
          // Informação do card
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tipo da refeição
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8.0,
                        vertical: 4.0,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green.shade200,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Text(
                        recipe.mealType,
                        style: const TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Título da receita
                Text(
                  recipe.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                // Informações nutricionais
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('${recipe.calorie.toInt()} kcal'),
                    Text('${recipe.carbs.toInt()}g carb'),
                    Text('${recipe.protein.toInt()}g proteínas'),
                    Text('${recipe.fat.toInt()}g gorduras'),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          // Botão de adicionar e saúde
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'Consumido? ${recipe.wasConsumed ? "Sim" : "Não"}',
                style: const TextStyle(fontSize: 12),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: onAdd,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightGreen,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: const Text('Adicionar'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
