import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sub_tracker/features/add_subscription/services/service_preset.dart';
import 'package:sub_tracker/theme.dart';

class ServiceNameField extends StatelessWidget {
  const ServiceNameField({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Autocomplete<String>(
      optionsBuilder: (textEditingValue) {
        final query = textEditingValue.text.trim().toLowerCase();
        if (query.isEmpty) {
          return servicePresets;
        } else {
          return servicePresets.where(
            (name) => name.toLowerCase().contains(query),
          );
        }
      },
      onSelected: (selection) {
        controller.text = selection;
        onChanged(selection);
      },
      fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
        return TextField(
          controller: controller,
          focusNode: focusNode,
          style: GoogleFonts.inter(color: AppTheme.onSurface, fontSize: 16),
          decoration: InputDecoration(
            filled: true,
            fillColor: AppTheme.fieldBackground,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppTheme.secondary, width: 1),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            suffixIcon: const Icon(
              Icons.keyboard_arrow_down,
              color: AppTheme.outline,
            ),
          ),
          onSubmitted: (_) => onFieldSubmitted(),
          onChanged: onChanged,
          
        );
      
      
      },
    );
  }
}
