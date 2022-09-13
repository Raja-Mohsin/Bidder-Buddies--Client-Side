import 'package:flutter/material.dart';

import '../widgets/drawer.dart';

class DeleteAccountScreen extends StatelessWidget {
  const DeleteAccountScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.primaryColor,
        centerTitle: true,
        elevation: 0,
        title: const Text('Settings'),
      ),
      drawer: UserDrawer('user'),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(
                left: 20,
                right: 60,
                top: 10,
                bottom: 20,
              ),
              child: const Text(
                'By tapping on \'Delete my Account\' your account will be permanently removed and this action will be irreversible. This will also delete all the bids, auctions and chats performed by this account',
              ),
            ),
            //other notifications button
            ListTile(
              title: const Text('Delete my Account'),
              subtitle:
                  const Text('Delete your account from this application.'),
              trailing: const Icon(Icons.arrow_forward),
              leading: const Icon(
                Icons.delete,
                color: Colors.red,
              ),
              onTap: () {},
            ),
            const Divider(),
          ],
        ),
      ),
    );
  }
}
