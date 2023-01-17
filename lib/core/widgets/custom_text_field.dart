import 'package:flutter/material.dart';
import 'package:lets_chat/utils/constants/colors_constants.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField(
      {super.key,
      required this.hint,
      this.prefix,
      this.style,
      required this.onChanged,
      this.value,
      this.readOnly = false});
  final String hint;
  final IconData? prefix;
  final TextStyle? style;
  final bool readOnly;
  final String? value;
  final Function(String) onChanged;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SizedBox(
      height: 60,
      child: TextFormField(
        readOnly: readOnly,
        maxLines: null,
        expands: true,
        initialValue: value,
        decoration: InputDecoration(
          prefixIcon: Icon(prefix),
          hintText: hint,
          hintStyle: Theme.of(context).textTheme.displaySmall?.copyWith(
                color: AppColors.grey,
                fontSize: size.width * 0.04,
                fontWeight: FontWeight.normal,
              ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
          enabledBorder:
              OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
          focusedBorder:
              OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
        ),
        style: Theme.of(context).textTheme.displaySmall?.copyWith(
              color: AppColors.black,
              fontSize: size.width * 0.05,
            ),
        onChanged: onChanged,
      ),
    );
  }
}
