import 'package:flutter/material.dart';

import '../../widgets/drawer.dart';
import '../../widgets/cancelled_orders_widget.dart';
import '../../widgets/active_orders_widget.dart';
import '../../widgets/completed_orders_widget.dart';

class MyOrdersScreen extends StatelessWidget {
  const MyOrdersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: theme.primaryColor,
          centerTitle: true,
          elevation: 0,
          title: const Text('Manage Orders'),
          bottom: const TabBar(
            indicatorColor: Colors.white,
            indicatorWeight: 3,
            tabs: [
              Tab(
                text: 'Active',
              ),
              Tab(
                text: 'Completed',
              ),
              Tab(
                text: 'Cancelled',
              ),
            ],
          ),
        ),
        drawer: UserDrawer('user'),
        body: const SafeArea(
          child: TabBarView(
            children: [
              ActiveOrdersWidget(),
              CompletedOrdersWidget(),
              CancelledOrdersWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
