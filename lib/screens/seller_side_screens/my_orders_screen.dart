import 'package:flutter/material.dart';

import '../../widgets/drawer.dart';
import './pending_orders_screen.dart';
import './active_orders_screen.dart';
import './completed_orders_screen.dart';

class MyOrdersScreenSeller extends StatefulWidget {
  const MyOrdersScreenSeller({Key? key}) : super(key: key);

  @override
  State<MyOrdersScreenSeller> createState() => _MyOrdersScreenStateSeller();
}

class _MyOrdersScreenStateSeller extends State<MyOrdersScreenSeller> {
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
                text: 'Pending',
              ),
              Tab(
                text: 'Active',
              ),
              Tab(
                text: 'Completed',
              ),
            ],
          ),
        ),
        drawer: UserDrawer('seller'),
        body: const SafeArea(
          child: TabBarView(
            children: [
              PendingOrdersWidget(),
              ActiveOrdersWidget(),
              CompletedOrdersWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
