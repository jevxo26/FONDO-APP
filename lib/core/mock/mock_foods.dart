import 'package:flutter/material.dart';
import '../../models/combo_item.dart';
import '../../models/food_item.dart';

class TrustFeature {
  final String label;
  final String subtitle;
  final IconData icon;

  const TrustFeature({
    required this.label,
    required this.subtitle,
    required this.icon,
  });
}

const List<TrustFeature> mockTrustFeatures = [
  TrustFeature(
    label: 'Fresh Daily',
    subtitle: 'Cooked fresh every morning',
    icon: Icons.eco_rounded,
  ),
  TrustFeature(
    label: '100% Halal',
    subtitle: 'Certified premium meats',
    icon: Icons.verified_rounded,
  ),
  TrustFeature(
    label: 'Coal Slow Oven',
    subtitle: 'Traditional dum pot aroma',
    icon: Icons.local_fire_department_rounded,
  ),
  TrustFeature(
    label: 'Chef Curated',
    subtitle: 'Heritage royal recipes',
    icon: Icons.star_rounded,
  ),
  TrustFeature(
    label: 'Fast Delivery',
    subtitle: 'Thermal hot in 30 mins',
    icon: Icons.electric_bolt_rounded,
  ),
];

const List<ComboItem> mockCombos = [
  ComboItem(
    id: 'combo_001',
    title: 'Family Feast',
    description:
        'The grand celebratory banquet for the whole family. Includes royal mutton kacchi, chicken roasts, crispy kebabs, chilled borhani, and traditional firni.',
    serves: '4–5 Persons',
    price: 1840,
    originalPrice: 2160,
    saveAmount: 320,
    items: [
      'Royal Mutton Kacchi (2x Full)',
      'Biye Bari Chicken Roast (4x)',
      'Jali Kebab Platter (4 pcs)',
      'Special Borhani Bottle (1L)',
      'House Firni in Clay Pots (4x)',
    ],
    freeDrink: '1L Borhani Bottle Included',
    isPopular: true,
    rating: 4.9,
    ratingCount: 124,
  ),
  ComboItem(
    id: 'combo_002',
    title: 'Weekend Brunch Bundle',
    description:
        'A spicy, aromatic weekend celebration with heritage mustard tehari, tender mutton rezala, and flaky mughlai paratha.',
    serves: '3–4 Persons',
    price: 1240,
    originalPrice: 1480,
    saveAmount: 240,
    items: [
      'Special Mustard Beef Tehari (2x)',
      'Mutton Rezala Bowl (2x)',
      'Mughlai Keema Paratha (2x)',
      'Special Borhani Bottle (500ml)',
    ],
    freeDrink: '500ml Borhani Included',
    isPopular: false,
    rating: 4.8,
    ratingCount: 78,
  ),
  ComboItem(
    id: 'combo_003',
    title: 'Date Night Platter',
    description:
        'A romantic culinary journey featuring our signature mutton kacchi, golden chicken roasts, firni dessert, and drinks.',
    serves: '2 Persons',
    price: 820,
    originalPrice: 980,
    saveAmount: 160,
    items: [
      'Royal Mutton Kacchi (1x Large)',
      'Chicken Roast (2x Leg Piece)',
      'House Firni in Clay Pot (2x)',
      'Special Borhani Cups (2x)',
    ],
    freeDrink: '2x Borhani Cups Included',
    isPopular: true,
    rating: 4.9,
    ratingCount: 95,
  ),
  ComboItem(
    id: 'combo_004',
    title: 'Office Team Lunch Box',
    description:
        'The productivity booster box packed with 5 fragrant chicken biryanis, crispy shami kebabs, fresh salad, and refreshing borhani.',
    serves: '5–6 Persons',
    price: 2120,
    originalPrice: 2500,
    saveAmount: 380,
    items: [
      'Fragrant Chicken Biryani (5x)',
      'Shami Kebab (5 pcs)',
      'Heritage Mixed Salad (5x)',
      'Special Borhani Individual Bottles (5x)',
    ],
    freeDrink: '5x Borhani Bottles Included',
    isPopular: false,
    rating: 4.7,
    ratingCount: 52,
  ),
];

const List<FoodItem> mockFoods = [
  // ── Breakfast ──
  FoodItem(
    id: 'f_001',
    name: 'Paratha & Dal',
    description:
        'Crispy multi-layered handmade paratha served with warm spiced chana dal and fresh heritage onion salad.',
    price: 120,
    category: 'Breakfast',
    rating: 4.3,
    ratingCount: 84,
    imageUrl: '',
    prepTime: '15-20 min',
    ingredients: ['Handmade Paratha', 'Chana Dal', 'Green Chili', 'Ghee'],
    dietaryTags: ['100% Halal', 'Vegetarian'],
    addOns: ['Extra Butter', 'Mixed Mango Pickle', 'Boiled Egg', 'Chicken Curry Side'],
  ),
  FoodItem(
    id: 'f_002',
    name: 'Bhorta Platter',
    description:
        'Assorted authentic smashed vegetables — smoky begun bhorta, spiced alu bhorta, and pungent shutki bhorta with fragrant rice.',
    price: 150,
    category: 'Breakfast',
    rating: 4.5,
    ratingCount: 92,
    imageUrl: '',
    prepTime: '15-20 min',
    ingredients: ['Begun Bhorta', 'Alu Bhorta', 'Shutki Bhorta', 'Steamed Rice', 'Mustard Oil'],
    dietaryTags: ['100% Halal', 'Traditional'],
    addOns: ['Extra Rice', 'Fried Egg', 'Extra Shutki Bhorta', 'Chana Dal'],
  ),
  FoodItem(
    id: 'f_003',
    name: 'Mughlai Paratha',
    description:
        'Crispy golden stuffed flaky pastry filled with seasoned minced meat, fresh herbs, egg, and fragrant Mughlai spices.',
    price: 200,
    category: 'Breakfast',
    rating: 4.7,
    ratingCount: 103,
    imageUrl: '',
    prepTime: '20-25 min',
    ingredients: ['Minced Beef', 'Farm Egg', 'Coriander', 'Crispy Pastry', 'Ghee'],
    dietaryTags: ['100% Halal', 'Chef Signature'],
    isSignature: true,
    addOns: ['Chicken Curry Side', 'Heritage Salad', 'Mint Chutney', 'Extra Egg'],
  ),

  // ── Lunch ──
  FoodItem(
    id: 'f_004',
    name: 'Chicken Biryani',
    description:
        'Long-grain fragrant basmati rice layered with tender saffron-marinated chicken, golden caramelized onions, and tender potatoes.',
    price: 220,
    category: 'Lunch',
    rating: 4.6,
    ratingCount: 148,
    imageUrl: '',
    prepTime: '25-35 min',
    ingredients: ['Basmati Rice', 'Marinated Chicken', 'Saffron', 'Fried Onions', 'Potatoes'],
    dietaryTags: ['100% Halal', 'Slow Cooked'],
    isPopular: true,
    addOns: ['Extra Chicken Leg Piece', 'Borhani Drink', 'Cool Raita', 'Heritage Salad'],
  ),
  FoodItem(
    id: 'f_005',
    name: 'Beef Khichuri',
    description:
        'Slow-cooked Kalijira rice and yellow lentils infused with tender beef chunks, aromatic garam masala, and pure ghee.',
    price: 290,
    category: 'Lunch',
    rating: 4.7,
    ratingCount: 86,
    imageUrl: '',
    prepTime: '20-30 min',
    ingredients: ['Kalijira Rice', 'Yellow Lentils', 'Tender Beef', 'Fried Onions', 'Ghee'],
    dietaryTags: ['100% Halal', 'Rainy Special'],
    addOns: ['Extra Beef Chunk', 'Fried Egg', 'Fresh Salad', 'Spicy Mango Pickle'],
  ),
  FoodItem(
    id: 'f_006',
    name: 'Royal Mutton Kacchi',
    description:
        'Our crowning jewel. Hand-selected baby mutton marinated in 18 royal spices, layered with fragrant Basmati, golden potato, prunes, and saffron.',
    price: 520,
    category: 'Lunch',
    rating: 4.9,
    ratingCount: 384,
    imageUrl: '',
    prepTime: '30-40 min',
    ingredients: ['Basmati Rice', 'Tender Baby Mutton', 'Zafran Saffron', 'Fried Potato', 'Prunes', 'Ghee'],
    dietaryTags: ['100% Halal', 'Chef Signature', 'Dum Cooked'],
    isSignature: true,
    isPopular: true,
    addOns: ['Extra Mutton Piece', 'Special Borhani (250ml)', 'Jali Kebab', 'House Firni'],
  ),
  FoodItem(
    id: 'f_007',
    name: 'Special Tehari',
    description:
        'Puran Dhaka heritage tehari cooked with small-grain aromatic Chinigura rice, tender mustard-marinated beef, and fiery green chilies.',
    price: 380,
    category: 'Lunch',
    rating: 4.8,
    ratingCount: 240,
    imageUrl: '',
    prepTime: '20-30 min',
    ingredients: ['Chinigura Rice', 'Diced Mustard Beef', 'Green Chilies', 'Mustard Oil', 'Whole Spices'],
    dietaryTags: ['100% Halal', 'Puran Dhaka Style'],
    isPopular: true,
    addOns: ['Extra Beef Chunks', 'Chilled Borhani', 'Boiled Egg', 'Cucumber Salad'],
  ),

  // ── Dinner ──
  FoodItem(
    id: 'f_008',
    name: 'Chicken Roast',
    description:
        'Grand wedding-style chicken leg quarter simmered in a velvety sweet-and-savory caramelized onion gravy with raisins, mawa, and ghee.',
    price: 350,
    category: 'Dinner',
    rating: 4.7,
    ratingCount: 165,
    imageUrl: '',
    prepTime: '20-25 min',
    ingredients: ['Deshi Chicken Quarter', 'Sweet Caramelized Onion Gravy', 'Raisins', 'Mawa', 'Ghee'],
    dietaryTags: ['100% Halal', 'Biye Bari Style'],
    addOns: ['Butter Naan', 'Morog Polao Side', 'Heritage Salad', 'Borhani'],
  ),
  FoodItem(
    id: 'f_009',
    name: 'Seekh Kebab Platter',
    description:
        'Succulent minced beef skewers seasoned with mint, coriander, and secret Mughlai spices, charcoal-grilled to smoky perfection.',
    price: 420,
    category: 'Dinner',
    rating: 4.8,
    ratingCount: 198,
    imageUrl: '',
    prepTime: '25-30 min',
    ingredients: ['Charcoal Minced Beef', 'Secret Mughlai Spices', 'Mint Chutney', 'Butter Naan'],
    dietaryTags: ['100% Halal', 'Charcoal Grilled'],
    isPopular: true,
    addOns: ['Extra Garlic Butter Naan', 'French Fries', 'Mint Yogurt Dip', 'Grilled Tomato'],
  ),
  FoodItem(
    id: 'f_010',
    name: 'Mutton Rezala',
    description:
        'Royal Mughlai classic featuring tender bone-in mutton simmered in a rich, fragrant white gravy made of yogurt, poppy seeds, makhana, and kewra water.',
    price: 480,
    category: 'Dinner',
    rating: 4.9,
    ratingCount: 142,
    imageUrl: '',
    prepTime: '25-35 min',
    ingredients: ['Bone-in Mutton', 'Yogurt Poppy Seed Gravy', 'Makhana', 'Kewra Water', 'Ghee'],
    dietaryTags: ['100% Halal', 'Heritage Mughlai'],
    isSignature: true,
    addOns: ['Rumali Roti (2x)', 'Butter Naan', 'Morog Polao', 'Special Borhani'],
  ),
  FoodItem(
    id: 'f_011',
    name: 'Prawns Malai Curry',
    description:
        'Fresh jumbo river prawns poached in a luscious, silky gravy of fresh coconut milk, golden turmeric, whole garam masala, and green chilies.',
    price: 550,
    category: 'Dinner',
    rating: 4.9,
    ratingCount: 125,
    imageUrl: '',
    prepTime: '25-35 min',
    ingredients: ['Golda Chingri Prawns', 'Fresh Coconut Milk', 'Mustard', 'Green Chilies', 'Ghee'],
    dietaryTags: ['100% Halal', 'Royal Bengal'],
    isSignature: true,
    addOns: ['Basmati Steamed Rice', 'Butter Naan', 'Cucumber Salad', 'Borhani'],
  ),
  FoodItem(
    id: 'f_012',
    name: 'House Firni',
    description:
        'Traditional Mughlai rice pudding crafted with finely crushed Kalijira rice, full cream milk, cardamom, saffron, and silvered pistachios in earthen pots.',
    price: 120,
    category: 'Dinner',
    rating: 4.9,
    ratingCount: 280,
    imageUrl: '',
    prepTime: 'Ready to serve',
    ingredients: ['Crushed Kalijira Rice', 'Full Cream Milk', 'Cardamom', 'Pistachios', 'Earthen Clay Pot'],
    dietaryTags: ['100% Halal', 'Sweet Heritage'],
    isPopular: true,
    addOns: ['Extra Pistachio Topping', 'Second Clay Pot Firni', 'Special Borhani'],
  ),
  FoodItem(
    id: 'f_013',
    name: 'Special Borhani',
    description:
        'Signature digestive spiced yogurt beverage blended with fresh mint, coriander, roasted mustard, cumin, and Himalayan black salt.',
    price: 90,
    category: 'Dinner',
    rating: 4.8,
    ratingCount: 310,
    imageUrl: '',
    prepTime: 'Ready to serve',
    ingredients: ['Thick Sour Curd', 'Mint & Coriander Paste', 'Roasted Mustard Seed', 'Black Salt'],
    dietaryTags: ['100% Halal', 'Digestive Drink'],
    isPopular: true,
    addOns: ['Upgrade to 500ml Bottle (+৳70)', 'Upgrade to 1L Bottle (+৳150)'],
  ),

  // ── Groceries ──
  FoodItem(
    id: 'f_014',
    name: 'Weekly Veg Box',
    description:
        'Fresh farm-harvested seasonal vegetables — potatoes, tomatoes, fresh spinach, bottle gourd, and eggplants.',
    price: 400,
    category: 'Groceries',
    rating: 4.2,
    ratingCount: 38,
    imageUrl: '',
    prepTime: 'Same Day Delivery',
    ingredients: ['Potatoes', 'Tomatoes', 'Spinach', 'Gourd', 'Eggplant'],
    dietaryTags: ['Farm Fresh', '100% Organic'],
    addOns: ['Extra Greens', 'Premium Rice 1kg', 'Lentils 500g', 'Cooking Oil 1L'],
  ),
  FoodItem(
    id: 'f_015',
    name: 'Dairy & Egg Pack',
    description:
        'Farm-fresh brown eggs (12 pcs), whole milk (2L), organic yogurt (500g), and country butter (200g).',
    price: 350,
    category: 'Groceries',
    rating: 4.4,
    ratingCount: 47,
    imageUrl: '',
    prepTime: 'Same Day Delivery',
    ingredients: ['Farm Eggs', 'Cow Milk', 'Sour Curd', 'Country Butter'],
    dietaryTags: ['Dairy Fresh', '100% Pure'],
    addOns: ['Cheese 200g', 'Extra Milk 1L', 'Deshi Ghee 250g', 'Cream 200ml'],
  ),
  FoodItem(
    id: 'f_016',
    name: 'Spice Essentials Kit',
    description:
        'Hand-ground turmeric, red chili, roasted cumin, coriander, royal garam masala, and bay leaves.',
    price: 180,
    category: 'Groceries',
    rating: 4.1,
    ratingCount: 22,
    imageUrl: '',
    prepTime: 'Same Day Delivery',
    ingredients: ['Turmeric', 'Chili Powder', 'Cumin', 'Coriander', 'Garam Masala'],
    dietaryTags: ['No Preservatives', '100% Pure'],
    addOns: ['Mustard Oil 500ml', 'Vinegar 250ml', 'Soy Sauce 200ml', 'Pure Honey 250g'],
  ),
];

