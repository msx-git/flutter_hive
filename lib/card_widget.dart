import 'package:flutter/material.dart';

class CardWidget extends StatelessWidget {
  const CardWidget({Key? key, required this.currentMember, required this.showInputForm, required this.deleteMember}) : super(key: key);

  final Map<String,dynamic> currentMember;
  final Function showInputForm;
  final Function deleteMember;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(
        top: 15.0,
        right: 15,
        left: 15,
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.person_outline_rounded, size: 20),
                    SizedBox(
                      width: 220,
                      child: Text(
                        ': ${currentMember['firstName']}  ${currentMember['lastName']}',
                        style: const TextStyle(
                            overflow: TextOverflow.ellipsis),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.badge_outlined, size: 20),
                    Text(': ${currentMember['position']}')
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.request_quote_outlined, size: 20),
                    Text(': ${currentMember['salary']}')
                  ],
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () =>
                      showInputForm(context, currentMember['key']),
                  icon: const Icon(Icons.edit),
                ),
                IconButton(
                  onPressed: () => deleteMember(currentMember['key']),
                  icon: const Icon(Icons.delete),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
