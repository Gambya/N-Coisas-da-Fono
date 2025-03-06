import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ncoisasdafono/domain/entities/patient.dart';
import 'package:ncoisasdafono/ui/patient/viewmodels/patient_register_view_model.dart';
import 'package:ncoisasdafono/ui/patient/viewmodels/patient_view_model.dart';
import 'package:ncoisasdafono/ui/patient/views/patient_details_view.dart';
import 'package:ncoisasdafono/ui/patient/views/patient_register_view.dart';
import 'package:provider/provider.dart';
import 'package:result_command/result_command.dart';

class PatientView extends StatefulWidget {
  final bool isSearching;
  const PatientView({super.key, required this.isSearching});

  @override
  State<PatientView> createState() => _PatientViewState();
}

class _PatientViewState extends State<PatientView> {
  late PatientViewModel _viewModel;
  final SearchController _searchController = SearchController();

  String _searchQuery = '';
  var _searchHistory = [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _viewModel = context.read<PatientViewModel>();
    _viewModel.loadPatientsCommand.addListener(_onLoadPatientCommandChanged);
    _viewModel.loadPatientsCommand.execute();
  }

  void _onLoadPatientCommandChanged() {
    if (_viewModel.loadPatientsCommand.isFailure) {
      final failure = _viewModel.loadPatientsCommand.value as FailureCommand;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(failure.error.toString()),
      ));
    }
  }

  @override
  void didUpdateWidget(covariant PatientView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isSearching != widget.isSearching) {
      setState(() {
        _isSearching = widget.isSearching;
      });
    }
  }

  @override
  void dispose() {
    _viewModel.loadPatientsCommand.removeListener(_onLoadPatientCommandChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(15.0),
          topRight: Radius.circular(15.0),
        ),
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              if (_isSearching) _showSearchBar(context),
              _showPatientsItems(),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromARGB(255, 193, 214, 255),
        mini: true,
        shape: CircleBorder(),
        onPressed: () {
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  PatientRegisterView(
                viewModel: context.read<PatientRegisterViewModel>(),
              ),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                const begin = Offset(0.0, 1.0);
                const end = Offset.zero;
                const curve = Curves.ease;

                var tween = Tween(begin: begin, end: end).chain(
                  CurveTween(curve: curve),
                );

                return SlideTransition(
                  position: animation.drive(tween),
                  child: child,
                );
              },
            ),
          );
        },
        child: const Icon(Icons.person_add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildPatientItem(Patient patient) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
          child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        PatientDetailsView(
                      patient: patient,
                    ),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      const begin = Offset(0.0, 1.0);
                      const end = Offset.zero;
                      const curve = Curves.ease;

                      var tween = Tween(begin: begin, end: end).chain(
                        CurveTween(curve: curve),
                      );

                      return SlideTransition(
                        position: animation.drive(tween),
                        child: child,
                      );
                    },
                  ),
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: [
                      if (patient.photoUrl != null &&
                          patient.photoUrl!.isNotEmpty)
                        Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Color.fromARGB(255, 215, 186, 232),
                                width: 3.0,
                              ),
                            ),
                            child: CircleAvatar(
                              backgroundImage:
                                  Image.file(File(patient.photoUrl!)).image,
                            ))
                      else
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Color.fromARGB(255, 215, 186, 232),
                              width: 3.0,
                            ),
                          ),
                          child: CircleAvatar(
                            backgroundColor: Color.fromARGB(255, 215, 186, 232),
                            child: Text(
                              patient.name.substring(0, 2).toUpperCase(),
                              style: TextStyle(
                                color: Color.fromARGB(255, 193, 214, 255),
                              ),
                            ),
                          ),
                        ),
                      SizedBox(width: 10.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 200.0,
                            child: Text(
                              patient.name,
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          Text(
                            patient.email,
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 12.0,
                              color: Colors.grey,
                              overflow: TextOverflow.ellipsis,
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                  IconButton(
                    icon: Icon(Icons.arrow_forward_ios),
                    color: Color.fromARGB(255, 215, 186, 232),
                    onPressed: () {},
                  ),
                ],
              )),
        ),
        SizedBox(height: 10),
        Divider(
          color: Colors.grey[200],
          thickness: 1.0,
          height: 0.0,
        ),
      ],
    );
  }

  _showSearchBar(BuildContext context) {
    return Container(
      color: Colors.transparent,
      padding: const EdgeInsets.all(8.0),
      child: SearchAnchor.bar(
        barHintText: 'Pesquisar...',
        barElevation: WidgetStatePropertyAll(0.0),
        searchController: _searchController,
        viewTrailing: [
          IconButton(
            onPressed: () {
              setState(() {
                _searchQuery = _searchController.text;
                _searchHistory.add(_searchController.text);
                _searchHistory = _searchHistory.reversed.toSet().toList();
                _searchController.closeView(_searchController.text);
                _viewModel.getFilteredPatients(_searchQuery);
              });
            },
            icon: Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                _searchController.clear();
                _searchQuery = '';
                _viewModel.getFilteredPatients(_searchQuery);
              });
            },
            icon: Icon(Icons.clear),
          ),
        ],
        barPadding: const WidgetStatePropertyAll<EdgeInsets>(
          EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        ),
        barShape: const WidgetStatePropertyAll<OutlinedBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
        ),
        constraints: const BoxConstraints(
          minHeight: 36,
        ),
        barBackgroundColor: const WidgetStatePropertyAll<Color>(
          Color.fromARGB(255, 240, 240, 240),
        ),
        barTextStyle: const WidgetStatePropertyAll<TextStyle>(
          TextStyle(fontSize: 14),
        ),
        suggestionsBuilder: (context, controller) {
          return [
            Wrap(
              children: List.generate(
                _searchHistory.length,
                (index) {
                  final item = _searchHistory[index];
                  return Padding(
                    padding: const EdgeInsets.only(left: 4.0, right: 4.0),
                    child: ChoiceChip(
                      label: Text(item),
                      selected: item == _searchController.text,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(24.0)),
                      ),
                      onSelected: (value) {
                        setState(() {
                          _searchQuery = item;
                          _searchController.closeView(item);
                        });
                      },
                    ),
                  );
                },
              ),
            ),
          ];
        },
      ),
    );
  }

  _showPatientsItems() {
    return Expanded(
      child: StreamBuilder<List<Patient>>(
        stream: _viewModel.patientsStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: Color.fromARGB(255, 193, 214, 255),
              ),
            );
          } else if (snapshot.hasError) {
            return Text('Erro: ${snapshot.error}');
          } else if (snapshot.hasData) {
            if (snapshot.data!.isEmpty) {
              return const Center(
                child: Text('Nenhuma consulta encontrada.'),
              );
            }

            return ListView.builder(
              itemBuilder: (context, index) {
                Patient patient = snapshot.data![index];
                return _buildPatientItem(patient);
              },
              itemCount: snapshot.data?.length ?? 0,
            );
          } else {
            return const Center(
              child: Text('Nenhum paciente encontrado.'),
            );
          }
        },
      ),
    );
  }
}
