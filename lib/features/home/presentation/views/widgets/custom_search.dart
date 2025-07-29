import 'package:flutter/material.dart';
import 'package:sweet_pal/core/utils/customtextfiled.dart';

class CustomSearch extends StatelessWidget {
  final TextEditingController controller;
  final Function(String)? onChanged;

  const CustomSearch({
    super.key,
    required this.controller,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return CustomTextFormField(
      controller: controller,
      onChanged: onChanged, 
      preffixIcon: const Icon(Icons.search),
      hintText: 'Search any Product..',
      textInputType: TextInputType.text,
    );
  }
}


