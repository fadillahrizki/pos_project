import 'package:flutter/material.dart';

import '../constants/custom_color.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    this.type = 'primary',
    this.size = 'normal',
    this.enabled = true,
    required this.onPressed,
    required this.label,
  });

  final String label, type, size;
  final GestureTapCallback onPressed;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    if (type == 'primary') {
      return ElevatedButton(
        onPressed: enabled ? onPressed : null,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: size == 'normal' ? 14 : 10),
          backgroundColor:
              enabled ? CustomColor().warning : CustomColor().secondary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Center(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black,
            ),
          ),
        ),
      );
    } else if (type == 'info') {
      return ElevatedButton(
        onPressed: enabled ? onPressed : null,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: size == 'normal' ? 14 : 10),
          backgroundColor:
              enabled ? CustomColor().primary : CustomColor().secondary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Center(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white,
            ),
          ),
        ),
      );
    } else if (type == 'danger') {
      return ElevatedButton(
        onPressed: enabled ? onPressed : null,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: size == 'normal' ? 14 : 10),
          backgroundColor: enabled ? Colors.red : CustomColor().secondary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Center(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white,
            ),
          ),
        ),
      );
    } else {
      return OutlinedButton(
        onPressed: enabled ? onPressed : null,
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: size == 'normal' ? 14 : 10),
          side: BorderSide(color: CustomColor().secondary),
          backgroundColor:
              enabled ? CustomColor().white : CustomColor().secondary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: CustomColor().primary,
              fontSize: 14,
            ),
          ),
        ),
      );
    }
  }
}
