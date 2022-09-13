import 'package:flutter/material.dart';

import '../widgets/drawer.dart';

class ChatHistorySettings extends StatelessWidget {
  const ChatHistorySettings({Key? key}) : super(key: key);

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
            //download chat button
            ListTile(
              title: const Text('Download My Chat'),
              subtitle: const Text('Download all of your chat in a local file'),
              trailing: const Icon(Icons.arrow_forward),
              onTap: () {},
            ),
            const Divider(),
            //delete chat button
            ListTile(
              title: const Text('Delete My Chat'),
              subtitle: const Text('Delete your chat from all auctions'),
              trailing: const Icon(Icons.arrow_forward),
              onTap: () {},
            ),
            const Divider(),
          ],
        ),
      ),
    );
  }
}
