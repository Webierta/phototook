import 'package:flutter/material.dart';

class NoImages extends StatelessWidget {
  final String message;
  const NoImages({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: LayoutBuilder(builder: (context, constraint) {
        return SizedBox(
          height: constraint.biggest.height,
          child: Column(
            children: [
              const Spacer(),
              Text(
                message,
                style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                      color: Theme.of(context).colorScheme.error,
                    ),
                textAlign: TextAlign.center,
              ),
              Expanded(
                child: Icon(
                  Icons.image_not_supported,
                  color: Theme.of(context).colorScheme.secondary,
                  size: constraint.maxHeight / 2,
                ),
              ),
              const Spacer(flex: 2),
            ],
          ),
        );
      }),
    );
  }
}
