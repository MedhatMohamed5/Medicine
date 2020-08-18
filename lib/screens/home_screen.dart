import 'package:flutter/material.dart';
import 'package:dr_ahmed_medicine/auth_service.dart';
import 'package:dr_ahmed_medicine/screens/auth_screens/login_screen.dart';
import 'package:dr_ahmed_medicine/screens/view_screens/view_customer.dart';
import 'package:dr_ahmed_medicine/screens/view_screens/view_product.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'customizations/menu_drawer.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  SharedPreferences sharedPref;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    getSharedPref();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  getSharedPref() async {
    sharedPref = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: MenuDrawer(),
      ),
      appBar: AppBar(
        title: Text(
          'Dr. Ahmed Clinic',
        ),
        bottom: TabBar(
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          controller: _tabController,
          tabs: [
            Tab(
              text: "Medicines",
            ),
            Tab(
              text: "Customers",
            ),
          ],
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              AuthService().signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => LoginScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: TabBarView(
          children: [
            ProductsScreen(),
            CustomersScreen(),
          ],
          controller: _tabController,
        ),
      ),
    );
  }
}
