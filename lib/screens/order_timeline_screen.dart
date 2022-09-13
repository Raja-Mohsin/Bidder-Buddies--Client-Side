import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../widgets/order_timeline_widget.dart';
import '../widgets/drawer.dart';
import '../widgets/order_chat_widget.dart';

class OrderTimelineScreen extends StatefulWidget {
  final String orderId;
  OrderTimelineScreen(this.orderId);

  @override
  State<OrderTimelineScreen> createState() => _OrderTimelineScreenState();
}

class _OrderTimelineScreenState extends State<OrderTimelineScreen> {
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: theme.primaryColor,
          centerTitle: true,
          elevation: 0,
          title: const Text('Order Timeline'),
          bottom: const TabBar(
            indicatorColor: Colors.white,
            indicatorWeight: 3,
            tabs: [
              Tab(
                text: 'Timeline',
              ),
              Tab(
                text: 'Chat',
              ),
            ],
          ),
        ),
        drawer: UserDrawer('user'),
        body: SafeArea(
          child: TabBarView(
            children: [
              OrderTimelineWidget(widget.orderId, 'user'),
              OrderChatWidget(widget.orderId),
            ],
          ),
        ),
      ),
    );
  }
}
