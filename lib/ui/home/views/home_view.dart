import 'package:flutter/material.dart';
import 'package:ncoisasdafono/ui/home/viewmodels/home_view_model.dart';
import 'package:ncoisasdafono/ui/home/widgets/consultation_view.dart';
import 'package:ncoisasdafono/ui/home/widgets/doctor_view.dart';
import 'package:ncoisasdafono/ui/home/widgets/patient_view.dart';

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

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

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
        title: Text("NCoisas da Fono"),
        backgroundColor: Color.fromARGB(
            255, 215, 186, 232), // Color.fromARGB(255, 193, 214, 255),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // Ação a ser executada ao clicar no ícone de menu
            },
          ),
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {
              // Ação a ser executada ao clicar no ícone de menu
            },
          ),
        ],
      ),
      body: Center(
        child: _widgetOptions[_selectedIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Color.fromARGB(255, 215, 186, 232),
        unselectedItemColor: Color.fromARGB(100, 215, 186, 232),
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.local_hospital), // Ícone para consultas
            label: 'Consultas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.accessible), // Ícone para pacientes
            label: 'Pacientes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.medical_information), // Ícone para perfil
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}
