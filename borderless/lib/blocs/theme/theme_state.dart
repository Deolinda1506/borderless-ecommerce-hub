import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class ThemeState extends Equatable {
  final bool isDarkMode;
  final ThemeData themeData;

  const ThemeState({required this.isDarkMode, required this.themeData});

  @override
  List<Object> get props => [isDarkMode, themeData];
}