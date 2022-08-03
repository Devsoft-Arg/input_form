import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/input_provider.dart';

class TitleForm extends StatelessWidget {
  const TitleForm(
    this.title, {
    Key? key,
  }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final decoration = context.read<InputProvider>().decoration;
    return Container(
      margin: const EdgeInsets.only(left: 43),
      padding: const EdgeInsets.symmetric(horizontal: 7),
      color: decoration.backgroundColor ?? theme.scaffoldBackgroundColor,
      child: Text(
        title,
        style: decoration.titleStyle ??
            theme.textTheme.titleSmall?.copyWith(
              color: theme.colorScheme.primary,
            ),
      ),
    );
  }
}
