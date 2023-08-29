import 'package:flutter/material.dart';
import 'package:rtv/class/ListProcedureVisualInspection.dart';
import 'package:rtv/controllers/VisualInspectionController.dart';

class VisualInspectionView extends StatefulWidget {
  @override
  _VisualInspectionViewState createState() => _VisualInspectionViewState();
}

class _VisualInspectionViewState extends State<VisualInspectionView> {
  final VisualInspectionController _controller = VisualInspectionController();
  List<List<ListProcedureInspection>> _procedureLists = [];
  @override
  void initState() {
    super.initState();
    _loadProcedures();
  }

  Future<void> _loadProcedures() async {
    try {
      List<ListProcedureInspection> visualInspection =
          await _controller.listInspectionProcedure();

      if (visualInspection.isNotEmpty) {
        for (int i = 0; i < 18; i++) {
          _procedureLists.add(visualInspection
              .where((procedure) => procedure.numero == i)
              .toList());
        }

        setState(() {});
      }
    } catch (e) {
      print(e);
    }
  }

void _showDefectsModal(BuildContext context, Defecto defect) {
  bool isOtherDefect = defect.abreviatura == 'OTROS';
  String description = '';
  String classification = '';
  List<bool> selectedRatings = [false, false, false];

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Defecto: ${defect.descripcion}'),
        content: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              if (isOtherDefect)
                Card(
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Text('Descripción del defecto:'),
                        TextField(
                          decoration: InputDecoration(labelText: 'Descripción'),
                          onChanged: (value) {
                            setState(() {
                              description = value;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              if (!isOtherDefect)
                Card(
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Text('Ubicación:'),
                        DropdownButton<String>(
                          value: '12',
                          items: [
                            DropdownMenuItem(
                              value: '12',
                              child: Text('12'),
                            ),
                            DropdownMenuItem(
                              value: '13',
                              child: Text('13'),
                            ),
                            DropdownMenuItem(
                              value: '14',
                              child: Text('14'),
                            ),
                            DropdownMenuItem(
                              value: '15',
                              child: Text('15'),
                            ),
                            DropdownMenuItem(
                              value: '16',
                              child: Text('16'),
                            ),
                            DropdownMenuItem(
                              value: '17',
                              child: Text('17'),
                            ),
                          ],
                          onChanged: (value) {
                            setState(() {
                              classification = value!;
                            });
                          },
                        ),
                        Text('Tomar foto:'),
                        // Add logic for capturing a photo
                        Text('Calificación:'),
                        Column(
                          children: [
                            CheckboxListTile(
                              title: Text('Calificación 1'),
                              value: selectedRatings[0],
                              onChanged: (value) {
                                setState(() {
                                  selectedRatings[0] = value!;
                                });
                              },
                            ),
                            CheckboxListTile(
                              title: Text('Calificación 2'),
                              value: selectedRatings[1],
                              onChanged: (value) {
                                setState(() {
                                  selectedRatings[1] = value!;
                                });
                              },
                            ),
                            CheckboxListTile(
                              title: Text('Calificación 3'),
                              value: selectedRatings[2],
                              onChanged: (value) {
                                setState(() {
                                  selectedRatings[2] = value!;
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
        actions: <Widget>[
          ElevatedButton(
            onPressed: () {
              // Implement your logic to save the defect details
              // You can use 'description', 'classification', and 'selectedRatings' here
              Navigator.of(context).pop();
            },
            child: Text("Guardar"),
          ),
        ],
      );
    },
  );
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _procedureLists.isNotEmpty
          ? Scrollbar(
              child: ListView(
                children: _procedureLists.map((procedures) {
                  return ExpansionPanelList(
                    elevation: 1,
                    expandedHeaderPadding: EdgeInsets.all(0),
                    expansionCallback: (int index, bool isExpanded) {
                      setState(() {
                        procedures[index].isExpanded = !isExpanded;
                      });
                    },
                    children: procedures.map((procedure) {
                      return ExpansionPanel(
                        headerBuilder: (BuildContext context, bool isExpanded) {
                          return ListTile(
                            title: RichText(
                              text: TextSpan(
                                style: DefaultTextStyle.of(context).style,
                                children: [
                                  TextSpan(
                                    text: 'Procedimiento ',
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  TextSpan(text: '${procedure.procedimiento}'),
                                ],
                              ),
                            ),
                          );
                        },
                        body: ListView.builder(
                          shrinkWrap: true,
                          itemCount: procedure.defectos.length,
                          itemBuilder: (BuildContext context, int index) {
                            return ListTile(
                              title: Text('Defecto: ${procedure.defectos[index].descripcion}'),
                              onTap: () {
                                _showDefectsModal(context, procedure.defectos[index]);
                              },
                            );
                          },
                        ),
                        isExpanded: procedure.isExpanded,
                      );
                    }).toList(),
                  );
                }).toList(),
              ),
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
