import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/dummy_data.dart';
import 'package:flutter_complete_guide/models/meal.dart';
import 'package:flutter_complete_guide/screens/filters_screen.dart';
import 'package:flutter_complete_guide/screens/meal_detail.dart';
import 'package:flutter_complete_guide/screens/taps_screen.dart';

import './screens/category_meals_screen.dart';
import './screens/categories_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Map<String, bool> _filters = {
    'gluten': false,
    'lactose': false,
    'vegan': false,
    'vegetarian': false,
  };

  List<Meal> _availableMeals = DUMMY_MEALS;
  List<Meal> _favouriteMeals = [];

  void _setFilters(Map<String, bool> filterData){
    setState(() {
      _filters = filterData;

      _availableMeals = DUMMY_MEALS.where((meal){
        if (_filters['gluten'] && !meal.isGlutenFree){
          return false;
        }
        if (_filters['lactose'] && !meal.isLactoseFree){
          return false;
        }
        if (_filters['vegan'] && !meal.isVegan){
          return false;
        }
        if (_filters['vegetarian'] && !meal.isVegetarian){
          return false;
        }
        return true;

      }).toList();
    });
  }


  void _toggleFavourites(String mealId){
   final existing_index =  _favouriteMeals.indexWhere((meal) => meal.id == mealId);
   if (existing_index >= 0){
     setState(() {
       _favouriteMeals.remove(existing_index);
     });
   } else{
     setState(() {
       _favouriteMeals.add(DUMMY_MEALS.firstWhere((meal) => meal.id == mealId));
     });
   }
  }
  bool _isMealFavourite(String id){
    return _favouriteMeals.any((meal) => meal.id == id);
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DeliMeals',
      theme: ThemeData(
        primarySwatch: Colors.pink,
        accentColor: Colors.amber,
        canvasColor: Color.fromRGBO(255, 254, 229, 1),
        fontFamily: 'Raleway',
        textTheme: ThemeData.light().textTheme.copyWith(
            bodyText1: TextStyle(
              color: Color.fromRGBO(20, 51, 51, 1),
            ),
            bodyText2: TextStyle(
              color: Color.fromRGBO(20, 51, 51, 1),
            ),
            headline6: TextStyle(
              fontSize: 20,
              fontFamily: 'RobotoCondensed',
              fontWeight: FontWeight.bold,
            )),
      ),
      // home: CategoriesScreen(),
      initialRoute: '/', // default is '/'
      routes: {
        '/': (ctx) => TapsScreen(_favouriteMeals),
        CategoryMealsScreen.routeName: (ctx) => CategoryMealsScreen(_availableMeals),
        MealDetail.routeName: (ctx) => MealDetail(_toggleFavourites, _isMealFavourite),
        FiltersScreen.routeName: (ctx) => FiltersScreen(_filters, _setFilters),
      },
    );
  }
}
