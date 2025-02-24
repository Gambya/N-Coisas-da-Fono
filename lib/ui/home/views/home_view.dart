import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:ncoisasdafono/ui/home/viewmodels/home_view_model.dart';
import 'package:ncoisasdafono/ui/consultation/views/consultation_view.dart';
import 'package:ncoisasdafono/ui/doctor/views/doctor_view.dart';
import 'package:ncoisasdafono/ui/patient/views/patient_view.dart';

class HomeView extends StatefulWidget {
  final HomeViewModel viewModel;
  const HomeView({super.key, required this.viewModel});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late HomeViewModel _viewModel;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _viewModel = widget.viewModel;
  }

  static final List<Widget> _widgetOptions = <Widget>[
    ConsultationView(),
    PatientView(),
    DoctorView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: Colors.white,
            radius: 20,
            child: ClipOval(
              child: Image.asset(
                'assets/images/logo192x189.png',
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        title: Text(
          "NCoisas da Fono",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Color.fromARGB(
            255, 215, 186, 232), // Color.fromARGB(255, 193, 214, 255),
        actions: [
          IconButton(
            icon: Icon(
              Icons.search,
              color: Colors.white,
            ),
            onPressed: () {
              // Ação a ser executada ao clicar no ícone de menu
            },
          ),
          IconButton(
            icon: Icon(
              Icons.more_vert,
              color: Colors.white,
            ),
            onPressed: () {
              // Ação a ser executada ao clicar no ícone de menu
            },
          ),
        ],
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              color: Colors.black.withValues(alpha: .1),
            )
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
            child: GNav(
              rippleColor: Colors.grey[300]!,
              hoverColor: Color.fromARGB(255, 215, 186, 232),
              gap: 8,
              activeColor: Color.fromARGB(255, 215, 186, 232),
              iconSize: 24,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              duration: Duration(milliseconds: 400),
              tabBackgroundColor: Colors.grey[100]!,
              color: Color.fromARGB(255, 215, 186, 232),
              tabs: [
                GButton(
                  icon: Icons.local_hospital,
                  text: 'Consultas',
                ),
                GButton(
                  icon: Icons.accessible,
                  text: 'Pacientes',
                ),
                GButton(
                  icon: Icons.medical_information,
                  text: 'Profile',
                ),
              ],
              selectedIndex: _selectedIndex,
              onTabChange: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
            ),
          ),
        ),
      ),
    );
  }
}
