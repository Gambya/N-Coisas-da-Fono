import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ncoisasdafono/domain/entities/consultation.dart';
import 'package:ncoisasdafono/ui/consultation/viewmodels/consultation_register_view_model.dart';
import 'package:ncoisasdafono/ui/consultation/views/consultation_detail_view.dart';
import 'package:ncoisasdafono/ui/consultation/views/consultation_register_view.dart';
import 'package:ncoisasdafono/ui/consultation/viewmodels/consultation_view_model.dart';
import 'package:provider/provider.dart';
import 'package:result_command/result_command.dart';

class ConsultationView extends StatefulWidget {
  final bool isSearching;
  const ConsultationView({super.key, required this.isSearching});

  @override
  State<ConsultationView> createState() => _ConsultationViewState();
}

class _ConsultationViewState extends State<ConsultationView> {
  late ConsultationViewModel _viewModel;
  final SearchController _searchController = SearchController();

  String _searchQuery = '';
  var _searchHistory = [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _viewModel = context.read<ConsultationViewModel>();
    _viewModel.loadConsultationCommand
        .addListener(_onLoadConsultationCommandChanged);

    _viewModel.loadConsultationCommand.execute();
  }

  void _onLoadConsultationCommandChanged() {
    if (_viewModel.loadConsultationCommand.isFailure) {
      final failure =
          _viewModel.loadConsultationCommand.value as FailureCommand;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(failure.error.toString()),
      ));
    }
  }

  @override
  void didUpdateWidget(covariant ConsultationView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isSearching != widget.isSearching) {
      setState(() {
        _isSearching = widget.isSearching;
      });
    }
  }

  @override
  void dispose() {
    _viewModel.loadConsultationCommand
        .removeListener(_onLoadConsultationCommandChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          if (_isSearching) _showSearchBar(context),
          _showConsultations(context),
        ],
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
                  ConsultationRegisterView(
                viewModel: context.read<ConsultationRegisterViewModel>(),
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
        child: const Icon(Icons.post_add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  _showConsultations(BuildContext context) {
    return Expanded(
      child: StreamBuilder<List<Consultation>>(
        stream: _viewModel.getFilteredConsultations(_searchQuery),
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
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Consultation consultation = snapshot.data![index];
                return InkWell(
                  onTap: () async {
                    await Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            ConsultationDetailView(
                          consultation: consultation,
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
                  child: _buildConsultationItem(consultation),
                );
              },
            );
          } else {
            return const Center(
              child: Text('Nenhuma consulta disponível para esta data.'),
            );
          }
        },
      ),
    );
  }

  _showSearchBar(BuildContext context) {
    return Container(
      color: Color.fromARGB(255, 215, 186, 232),
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
                _viewModel.getFilteredConsultations(_searchQuery);
              });
            },
            icon: Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                _searchController.clear();
                _searchQuery = '';
                _viewModel.getFilteredConsultations(_searchQuery);
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

  Widget _buildConsultationItem(Consultation consultation) {
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
                        ConsultationDetailView(
                      consultation: consultation,
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
                      if (consultation.patient.target!.photoUrl != null &&
                          consultation.patient.target!.photoUrl!.isNotEmpty)
                        Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Color.fromARGB(255, 215, 186, 232),
                                width: 3.0,
                              ),
                            ),
                            child: CircleAvatar(
                              backgroundImage: Image.file(File(
                                      consultation.patient.target!.photoUrl!))
                                  .image,
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
                              consultation.patient.target!.name
                                  .substring(0, 2)
                                  .toUpperCase(),
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
                              consultation.patient.target!.name,
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Montserrat',
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.calendar_today,
                                      color: Colors.grey,
                                      size: 10,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      DateFormat('dd/MM/yyyy')
                                          .format(consultation.dateTime!),
                                      style: const TextStyle(
                                        fontSize: 10,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.access_time,
                                      color: Colors.grey,
                                      size: 10,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      _formatTimeOfDay(
                                        TimeOfDay.fromDateTime(
                                            consultation.dateTime!),
                                      ),
                                      style: const TextStyle(
                                        fontSize: 10,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                  IconButton(
                    icon: Icon(Icons.arrow_forward_ios),
                    color: Color.fromARGB(255, 215, 186, 232),
                    onPressed: () {},
                  )
                ],
              )),
        ),
        SizedBox(height: 10),
        Divider(
          color: Colors.grey[200], // Cor da linha
          thickness: 1.0, // Espessura da linha
          height: 0.0, // Altura total (sem espaço extra)
        ),
      ],
    );
  }

  String _formatTimeOfDay(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');

    return '$hour:$minute';
  }
}
