import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';

class FilterPage extends StatefulWidget {
  const FilterPage({super.key});

  @override
  State<FilterPage> createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  // Valeurs pour le RangeSlider
  RangeValues _currentRangeValues = const RangeValues(5000, 200000);

  // Simulation des catégories sélectionnées
  final List<String> _categories = [
    "Vendeurs du marché",
    "Swiss Mart",
    "Maison Galaxy",
    "SK",
    "Vendeurs du marché ",
    "Swiss Mart ",
    "Maison Galaxy ",
    "SK ",
  ];
  final List<String> _selectedCategories = ["Maison Galaxy"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color(0xFFF5F5F5), // Fond légèrement gris comme sur l'image
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new,
              color: Colors.black, size: 20),
          onPressed: () => context.pop(),
        ),
        title: const Text("Filtre",
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 18)),
        centerTitle: true,
        actions: [
          TextButton(
              onPressed: () {},
              child: const Text("Supprimer le filtre",
                  style: TextStyle(color: Colors.grey, fontSize: 12))),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // --- SECTION PRIX ---
            _buildSectionCard(
              title: "Prix",
              onClear: () {},
              child: Column(
                children: [
                  Text(
                    "${_currentRangeValues.start.round()} Fc - ${_currentRangeValues.end.round()} Fc",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 20),
                  RangeSlider(
                    values: _currentRangeValues,
                    min: 0,
                    max: 500000,
                    activeColor: AppColors.primary,
                    inactiveColor: Colors.grey.shade300,
                    onChanged: (RangeValues values) {
                      setState(() => _currentRangeValues = values);
                    },
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: _buildPriceInput(
                              _currentRangeValues.start.round().toString())),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Text("—"),
                      ),
                      Expanded(
                          child: _buildPriceInput(
                              _currentRangeValues.end.round().toString())),
                    ],
                  )
                ],
              ),
            ),

            const SizedBox(height: 16),

            // --- SECTION CATEGORIES ---
            _buildSectionCard(
              title: "Catégories",
              onClear: () {},
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _categories.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final cat = _categories[index];
                  final isSelected = _selectedCategories.contains(cat.trim());
                  return Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                          child:
                              Text(cat, style: const TextStyle(fontSize: 14))),
                      Checkbox(
                        value: isSelected,
                        activeColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4)),
                        onChanged: (val) {
                          setState(() {
                            if (val!) {
                              _selectedCategories.add(cat.trim());
                            } else {
                              _selectedCategories.remove(cat.trim());
                            }
                          });
                        },
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget pour les cartes blanches arrondies
  Widget _buildSectionCard(
      {required String title,
      required Widget child,
      required VoidCallback onClear}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18)),
              GestureDetector(
                onTap: onClear,
                child: const Text("Supprimer le filtre",
                    style: TextStyle(color: Colors.grey, fontSize: 11)),
              ),
            ],
          ),
          const SizedBox(height: 20),
          child,
        ],
      ),
    );
  }

  // Widget pour les champs de saisie du prix en bas du slider
  Widget _buildPriceInput(String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(value, style: const TextStyle(color: Colors.grey)),
          const Text("Fc", style: TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
