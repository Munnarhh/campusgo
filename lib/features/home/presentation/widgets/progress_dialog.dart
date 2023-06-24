import 'package:flutter/material.dart';

class ProgressDialog extends StatelessWidget {
  final String? message;
  const ProgressDialog({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          padding: const EdgeInsets.symmetric(
            vertical: 20,
            horizontal: 30,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(3),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 30,
                width: 30,
                child: CircularProgressIndicator(
                  strokeWidth: 4,
                  color: Colors.green[800],
                ),
              ),
              const SizedBox(width: 30),
              Expanded(
                child: Text(
                  message ?? 'Loading...',
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        fontSize: 14,
                        color: Colors.black.withOpacity(0.80),
                      ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
