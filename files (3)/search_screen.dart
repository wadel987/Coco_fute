// lib/screens/search_screen.dart

import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  String? selectedRegion;
  String? selectedCategory;
  bool sortByPrice = false;
  bool showOnlyDeals = false;

  final List<String> regions = ['Tous', 'Moorea', 'Tahiti', 'Raiatea', 'Bora Bora'];
  
  final List<String> categories = [
    'Tous',
    'Alimentation',
    'Fruits & Légumes',
    'Surgelés',
    'Boissons',
    'Hygiène',
    'Électronique',
    'Vêtements',
  ];

  final List<Map<String, dynamic>> searchResults = [
    {
      'name': 'Carottes en dés en conserve',
      'brand': 'DEL MONTE',
      'price': 257,
      'stores': 3,
      'discount': '-75%',
      'badge': 'EPICERIE',
    },
    {
      'name': 'Riz blanc long grain en sachet',
      'brand': 'SUNLONG',
      'price': 136,
      'stores': 5,
      'discount': '-74%',
      'badge': 'EPICERIE',
    },
    {
      'name': 'Oranges fraîches',
      'brand': 'IMPORTÉES',
      'price': 450,
      'stores': 4,
      'discount': '-25%',
      'badge': 'FRAIS',
    },
    {
      'name': 'Lait pasteurisé 1L',
      'brand': 'LOCAL',
      'price': 189,
      'stores': 6,
      'discount': '-10%',
      'badge': 'FRAIS',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: const Text('Rechercher un produit'),
      ),
      body: Column(
        children: [
          // ==================== BARRE DE RECHERCHE ====================
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Rechercher un produit...',
                prefixIcon: const Icon(Icons.search, color: AppColors.textHint),
                suffixIcon: _searchController.text.isNotEmpty
                    ? GestureDetector(
                        onTap: () {
                          _searchController.clear();
                          setState(() {});
                        },
                        child: const Icon(Icons.clear, color: AppColors.textHint),
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(
                    color: AppColors.primary,
                    width: 2,
                  ),
                ),
                filled: true,
                fillColor: AppColors.bgLight,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              onChanged: (value) {
                setState(() {});
              },
            ),
          ),

          // ==================== FILTRES ====================
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                // Filtre Région
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterButton(
                    icon: Icons.location_on,
                    label: 'Région',
                    onPressed: () {
                      _showRegionBottomSheet();
                    },
                  ),
                ),

                // Filtre Catégorie
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterButton(
                    icon: Icons.category,
                    label: 'Catégorie',
                    onPressed: () {
                      _showCategoryBottomSheet();
                    },
                  ),
                ),

                // Filtre Prix
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterButton(
                    icon: Icons.trending_down,
                    label: 'Prix',
                    onPressed: () {
                      setState(() => sortByPrice = !sortByPrice);
                    },
                    isActive: sortByPrice,
                  ),
                ),

                // Filtre Offres
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterButton(
                    icon: Icons.local_offer,
                    label: 'Offres',
                    onPressed: () {
                      setState(() => showOnlyDeals = !showOnlyDeals);
                    },
                    isActive: showOnlyDeals,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // ==================== RÉSULTATS ====================
          Expanded(
            child: searchResults.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(
                          Icons.search,
                          size: 64,
                          color: AppColors.textHint,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Aucun produit trouvé',
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: searchResults.length,
                    itemBuilder: (context, index) {
                      final product = searchResults[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: SearchResultCard(
                          name: product['name'],
                          brand: product['brand'],
                          price: product['price'],
                          stores: product['stores'],
                          discount: product['discount'],
                          badge: product['badge'],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  void _showRegionBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Sélectionner une région',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...regions.map((region) => GestureDetector(
              onTap: () {
                setState(() => selectedRegion = region);
                Navigator.pop(context);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Text(
                  region,
                  style: TextStyle(
                    fontSize: 14,
                    color: selectedRegion == region
                        ? AppColors.primary
                        : AppColors.textPrimary,
                    fontWeight: selectedRegion == region
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
              ),
            )),
          ],
        ),
      ),
    );
  }

  void _showCategoryBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Sélectionner une catégorie',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...categories.map((category) => GestureDetector(
              onTap: () {
                setState(() => selectedCategory = category);
                Navigator.pop(context);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Text(
                  category,
                  style: TextStyle(
                    fontSize: 14,
                    color: selectedCategory == category
                        ? AppColors.primary
                        : AppColors.textPrimary,
                    fontWeight: selectedCategory == category
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
              ),
            )),
          ],
        ),
      ),
    );
  }
}

// ==================== BOUTON FILTRE ====================

class FilterButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  final bool isActive;

  const FilterButton({
    Key? key,
    required this.icon,
    required this.label,
    required this.onPressed,
    this.isActive = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          color: isActive ? AppColors.primary : AppColors.bgLight,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isActive ? AppColors.primary : AppColors.border,
          ),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 8,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 18,
              color: isActive ? Colors.white : AppColors.textSecondary,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isActive ? Colors.white : AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==================== CARTE RÉSULTAT RECHERCHE ====================

class SearchResultCard extends StatefulWidget {
  final String name;
  final String brand;
  final int price;
  final int stores;
  final String discount;
  final String badge;

  const SearchResultCard({
    Key? key,
    required this.name,
    required this.brand,
    required this.price,
    required this.stores,
    required this.discount,
    required this.badge,
  }) : super(key: key);

  @override
  State<SearchResultCard> createState() => _SearchResultCardState();
}

class _SearchResultCardState extends State<SearchResultCard> {
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
        color: Colors.white,
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.getBadgeColor(widget.badge),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    widget.badge,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.name,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  widget.brand,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${widget.stores} magasin${widget.stores > 1 ? 's' : ''}',
                  style: const TextStyle(
                    fontSize: 10,
                    color: AppColors.textHint,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() => isFavorite = !isFavorite);
                },
                child: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? Colors.red : AppColors.textHint,
                  size: 20,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${widget.price}xpf',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                widget.discount,
                style: const TextStyle(
                  fontSize: 11,
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
