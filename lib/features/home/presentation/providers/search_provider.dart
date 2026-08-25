import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../models/food_item.dart';
import '../../../../core/mock/mock_foods.dart';

// State model for search
class SearchState {
  final List<String> recent;
  final String query;
  final List<FoodItem> results;

  SearchState({required this.recent, required this.query, required this.results});

  SearchState copyWith({List<String>? recent, String? query, List<FoodItem>? results}) {
    return SearchState(
      recent: recent ?? this.recent,
      query: query ?? this.query,
      results: results ?? this.results,
    );
  }
}

class SearchNotifier extends StateNotifier<SearchState> {
  static const _recentKey = 'recent_searches';
  SearchNotifier() : super(SearchState(recent: [], query: '', results: [])) {
    _loadRecent();
  }

  Future<void> _loadRecent() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_recentKey) ?? [];
    state = state.copyWith(recent: list);
  }

  Future<void> _saveRecent(List<String> recent) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_recentKey, recent);
  }

  void addSearch(String term) {
    if (term.isEmpty) return;
    final updated = [term, ...state.recent.where((e) => e != term)];
    state = state.copyWith(recent: updated);
    _saveRecent(updated);
  }

  void removeSearch(int index) {
    final updated = List<String>.from(state.recent)..removeAt(index);
    state = state.copyWith(recent: updated);
    _saveRecent(updated);
  }

  void clearAll() {
    state = state.copyWith(recent: []);
    _saveRecent([]);
  }

  void setQuery(String q) {
    state = state.copyWith(query: q);
    _filter();
  }

  void _filter() {
    if (state.query.isEmpty) {
      state = state.copyWith(results: []);
      return;
    }
    final lower = state.query.toLowerCase();
    final filtered = mockFoods.where((food) {
      return food.name.toLowerCase().contains(lower) ||
          food.category.toLowerCase().contains(lower);
    }).toList();
    state = state.copyWith(results: filtered);
  }
}

final searchProvider = StateNotifierProvider<SearchNotifier, SearchState>((ref) => SearchNotifier());
