import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const String btcAddress = '15ZpNzqbYFx9P7wg4U438JMwZr2q3W6fkS';

class BtcWalletAddress extends StatelessWidget {
  const BtcWalletAddress({super.key});

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.fitWidth,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(
            Radius.circular(8.0),
          ),
          border: Border.all(
            color: Theme.of(context).colorScheme.onSurface,
            style: BorderStyle.solid,
          ),
        ),
        child: Row(
          children: [
            Container(
              height: 50,
              padding: const EdgeInsets.all(8.0),
              decoration: ShapeDecoration(
                color: Theme.of(context).colorScheme.secondaryContainer,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(8),
                    topLeft: Radius.circular(8),
                    bottomRight: Radius.zero,
                    topRight: Radius.zero,
                  ),
                ),
              ),
              child: const Align(
                alignment: Alignment.center,
                child: Text(
                  btcAddress,
                  //style: TextStyle(color: Color(0xFF455A64)),
                ),
              ),
            ),
            Container(
              height: 50,
              decoration: BoxDecoration(
                border: Border(
                  left: BorderSide(
                    color: Theme.of(context).colorScheme.onSurface,
                    style: BorderStyle.solid,
                  ),
                ),
              ),
              child: IconButton(
                icon: const Icon(Icons.copy),
                onPressed: () async {
                  await Clipboard.setData(
                    const ClipboardData(text: btcAddress),
                  );
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('BTC Address copied to Clipboard.'),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
