import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:ncoisasdafono/domain/entities/doctor.dart';
import 'package:ncoisasdafono/ui/home/viewmodels/home_view_model.dart';
import 'package:ncoisasdafono/ui/consultation/views/consultation_view.dart';
import 'package:ncoisasdafono/ui/doctor/views/doctor_view.dart';
import 'package:ncoisasdafono/ui/patient/views/patient_view.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeView extends StatefulWidget {
  final HomeViewModel viewModel;
  const HomeView({super.key, required this.viewModel});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with TickerProviderStateMixin {
  late HomeViewModel _viewModel;
  int _selectedIndex = 0;
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _viewModel = widget.viewModel;
    _viewModel.loadDoctorCommand.execute();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> widgetOptions = <Widget>[
      ConsultationView(isSearching: _isSearching),
      PatientView(isSearching: _isSearching),
      DoctorView(),
    ];
    return Scaffold(
      appBar: _showAppBar(),
      body: Center(
        child: widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: _showBottomNavigationBar(),
    );
  }

  _showAppBar() {
    return AppBar(
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: StreamBuilder<Doctor>(
          stream: _viewModel.doctorStream,
          builder: (BuildContext context, AsyncSnapshot<Doctor> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Color.fromARGB(255, 193, 214, 255),
                    width: 2.0,
                  ),
                ),
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey[200],
                  child: Icon(
                    Icons.person,
                    size: 30,
                    color: Colors.grey[800],
                  ),
                ),
              );
            } else if (snapshot.hasData) {
              final doctor = snapshot.data!;
              if (doctor.photoUrl == null || doctor.photoUrl!.isEmpty) {
                return Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Color.fromARGB(255, 193, 214, 255),
                      width: 2.0,
                    ),
                  ),
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Text(
                      doctor.name.substring(0, 2).toUpperCase(),
                      style: TextStyle(
                        color: Color.fromARGB(255, 215, 186, 232),
                      ),
                    ),
                  ),
                );
              }
              return Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Color.fromARGB(255, 193, 214, 255),
                    width: 2.0,
                  ),
                ),
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  backgroundImage:
                      Image.file(File(snapshot.data!.photoUrl!)).image,
                  radius: 20,
                ),
              );
            } else {
              return Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Color.fromARGB(255, 193, 214, 255),
                    width: 2.0,
                  ),
                ),
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey[200],
                  child: Icon(
                    Icons.person,
                    size: 30,
                    color: Colors.grey[800],
                  ),
                ),
              );
            }
          },
        ),
      ),
      title: Text(
        "NCoisas da Fono",
        style: GoogleFonts.hennyPenny(
          color: Colors.white,
          fontWeight: FontWeight.bold,
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
            setState(() {
              _isSearching = !_isSearching;
            });
          },
        ),
      ],
    );
  }

  _showBottomNavigationBar() {
    return Container(
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
                text: 'Perfil',
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
    );
  }
}
