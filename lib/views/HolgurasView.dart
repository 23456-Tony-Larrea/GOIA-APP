import 'package:flutter/material.dart';
import 'package:rtv/class/Holguras.dart';
import 'package:rtv/controllers/HolgurasController.dart';

class HolgurasView extends StatefulWidget {
  @override
  _HolgurasViewState createState() => _HolgurasViewState();
}

class _HolgurasViewState extends State<HolgurasView> {
  final HolgurasController _controller = HolgurasController();
  List<List<Holguras>> _procedureListHolguras = [];

  @override
  void initState() {
    super.initState();
    _loadProcedures();
  }

  Future<void> _loadProcedures() async {
    try {
      List<Holguras> holguras =
          await _controller.listHolguras();

      if (holguras.isNotEmpty) {
        for (int i = 0; i < 18; i++) {
          _procedureListHolguras.add(holguras
              .where((holgurass) => holgurass.abreviatura == i)
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
    List<bool> selectedRatings = [false, false, false];

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              title: Text('Defecto: ${defect.descripcion}'),
              onTap: () {},
            ),
            Divider(),
            if (isOtherDefect)
              Column(
                children: [
                  Text('Descripción del defecto:'),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: TextField(
                      decoration: InputDecoration(labelText: 'Descripción'),
                      onChanged: (value) {
                        setState(() {
                          description = value;
                        });
                      },
                    ),
                  ),
                  SizedBox(height: 10),
                ],
              ),
            if (!isOtherDefect)
              Column(
                children: [
                  Text('Calificación:'),
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
                  CheckboxListTile(
                    title: Text('Cancelar'),
                    value: selectedRatings[2],
                    onChanged: (value) {
                      setState(() {
                        selectedRatings[2] = value!;
                      });
                    },
                  ),
                ],
              ),
            ElevatedButton(
              onPressed: () {
                // Implement your logic to save the defect details
                // You can use 'description' and 'selectedRatings' here
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
      body: _procedureListHolguras.isNotEmpty
          ? Scrollbar(
              child: ListView(
                children: _procedureListHolguras.map((procedures) {
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
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
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
                              title: Text(
                                  'Defecto: ${procedure.defectos[index].descripcion}'),
                              onTap: () {
                                _showDefectsModal(
                                    context, procedure.defectos[index]);
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
