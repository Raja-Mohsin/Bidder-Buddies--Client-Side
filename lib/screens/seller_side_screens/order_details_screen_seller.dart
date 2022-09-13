import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import '../../widgets/drawer.dart';
import '../../widgets/order_chat_widget.dart';
import '../../widgets/order_timeline_widget.dart';

class OrderDetailsScreenSeller extends StatelessWidget {
  final String orderId;
  OrderDetailsScreenSeller(this.orderId);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        drawer: UserDrawer('seller'),
        appBar: AppBar(
          backgroundColor: theme.primaryColor,
          centerTitle: true,
          elevation: 0,
          title: const Text('Manage Order'),
          bottom: const TabBar(
            indicatorColor: Colors.white,
            indicatorWeight: 3,
            tabs: [
              Tab(
                text: 'Manage',
              ),
              Tab(
                text: 'Chat',
              ),
            ],
          ),
        ),
        body: SafeArea(
          child: TabBarView(
            children: [
              OrderTimelineWidget(orderId, 'seller'),
              OrderChatWidget(orderId),
            ],
          ),
        ),
      ),
    );
  }
}
