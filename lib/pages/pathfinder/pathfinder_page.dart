// ignore_for_file: avoid_dynamic_calls, avoid_print, prefer_single_quotes, require_trailing_commas, unused_local_variable

import 'dart:convert';
import 'dart:developer';
import 'package:dijkstra/dijkstra.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:campus_app/pages/home/widgets/page_navigation_animation.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:campus_app/pages/pathfinder/data.dart';

class RaumfinderPage extends StatefulWidget {
  final GlobalKey<AnimatedEntryState> pageEntryAnimationKey;
  final GlobalKey<AnimatedExitState> pageExitAnimationKey;

  const RaumfinderPage({
    Key? key,
    required this.pageEntryAnimationKey,
    required this.pageExitAnimationKey,
  }) : super(key: key);

  @override
  State<RaumfinderPage> createState() => RaumfinderPageState();
}

class RaumfinderPageState extends State<RaumfinderPage> {
  LocationData? currentLocation;
  List<LatLng> waypoints = [];
  final TextEditingController _searchController = TextEditingController();
  FocusNode _focusNode = FocusNode();

  final Map<String, LatLng> predefinedLocations = {
    'UFO': const LatLng(51.448051, 7.259111),
    'U35-Haltestelle': const LatLng(51.447198, 7.259043),
    'UNICENTER': const LatLng(51.447985, 7.258623),
    'MZ': const LatLng(51.446053, 7.259574),
    'SH': const LatLng(51.445724, 7.259661),
    'SSC': const LatLng(51.446138, 7.260922),
    'UV': const LatLng(51.445772, 7.260552),
    'UB': const LatLng(51.445127, 7.260327),
    'GAMINGHUB': const LatLng(51.445211, 7.259726),
    'REPAIR CAFE': const LatLng(51.445029, 7.259882),
    'AUDIMAX': const LatLng(51.444118, 7.261505),
    'MENSA': const LatLng(51.443282, 7.262258),
    'VZ': const LatLng(51.442925, 7.262552),
    'CASPO': const LatLng(51.442723, 7.262436),
    'MA': const LatLng(51.444993, 7.258908),
    'MB/TZR': const LatLng(51.444652, 7.2577),
    'MC/VC': const LatLng(51.444214, 7.256587),
    'MAFO': const LatLng(51.444733, 7.259557),
    'MABF': const LatLng(51.445159, 7.258016),
    'HMA': const LatLng(51.444392, 7.258677),
    'KULTUR CAFE': const LatLng(51.445886, 7.259654),
    'FNO': const LatLng(51.445254, 7.261878),
    'HZO': const LatLng(51.44478, 7.262698),
    'IA': const LatLng(51.445949, 7.262607),
    'IB': const LatLng(51.446348, 7.263733),
    'IC': const LatLng(51.446741, 7.264835),
    'ID': const LatLng(51.447127, 7.266222),
    //'ZGH': const LatLng(),
    'HIA': const LatLng(51.445592, 7.263637),
    'ICFW': const LatLng(51.446185, 7.264557),
    'HIB': const LatLng(51.446009, 7.26471),
    'ICFO': const LatLng(51.446595, 7.265687),
    'HIC': const LatLng(51.446461, 7.26581),
    'HID': const LatLng(51.446809, 7.266467),
    'CC': const LatLng(51.443973, 7.259845),
    'Q-WEST': const LatLng(51.44403, 7.258903),
    'GA': const LatLng(51.443491, 7.25955),
    'GB': const LatLng(51.443106, 7.25845),
    'GC': const LatLng(51.442715, 7.257316),
    'GD': const LatLng(51.44226, 7.256181),
    'HGA': const LatLng(51.443737, 7.259958),
    'HGB': const LatLng(51.443342, 7.258866),
    'HGC': const LatLng(51.442974, 7.257662),
    'GCFW': const LatLng(51.442346, 7.256945),
    'GAFO': const LatLng(51.442847, 7.260564),
    'GABF': const LatLng(51.442539, 7.259553),
    'GBCF': const LatLng(51.442138, 7.258386),
    'UniKids': const LatLng(51.441977, 7.261644),
    'NB': const LatLng(51.444603, 7.264508),
    'NC': const LatLng(51.445032, 7.26556),
    'ND': const LatLng(51.445321, 7.266759),
    'HNA': const LatLng(51.444544, 7.263566),
    'HNB': const LatLng(51.445048, 7.265095),
    'HNC': const LatLng(51.445389, 7.266204),
    'NBCF': const LatLng(51.444019, 7.265737),
    'NCDF': const LatLng(51.444437, 7.266948),
    'NDEF': const LatLng(51.444832, 7.26814),
    'ZN': const LatLng(51.44509, 7.268653),
    'NT': const LatLng(51.443536, 7.265527),
    'RUBION': const LatLng(51.443657, 7.266155),
    'Isotopenlabor': const LatLng(51.444018, 7.267117),
    'ZEMOS': const LatLng(51.445633, 7.268131),
    'BMZ': const LatLng(51.444561, 7.255235),
    'ZKF': const LatLng(51.445523, 7.258071),
    'IAN': const LatLng(51.446647, 7.261938),
    'IBN': const LatLng(51.447, 7.262752),
    'ICN': const LatLng(51.447448, 7.263219),
    'IDN': const LatLng(51.447889, 7.263472),

/*
    'Wahlurne: Fakultät für Mathematik': const LatLng(51.446348, 7.263733),
    'Wahlurne: Fakultät für Geowissenschaften': const LatLng(51.446348, 7.263733),
    'Wahlurne: Fakultät für Psychologie': const LatLng(51.446348, 7.263733),
    'Wahlurne: International Graduate School of Neuroscience (IGSN)': const LatLng(51.446348, 7.263733),

    'Wahlurne: Fakultät für Maschinenbau': const LatLng(51.446741, 7.264835),
    'Wahlurne: Fakultät für Bau- und Umweltingenieurwissenschaften': const LatLng(51.446741, 7.264835),
    'Wahlurne: Interdisciplinary Centre for Advanced Materials Simulation (ICAMS)': const LatLng(51.446741, 7.264835),

    'Wahlurne: Fakultät für Elektrotechnik und Informationstechnik': const LatLng(51.447127, 7.266222),

    'Wahlurne: Fakultät für Biologie und Biotechnologie': const LatLng(51.445032, 7.26556),
    'Wahlurne: Fakultät für Chemie und Biochemie': const LatLng(51.445032, 7.26556),
    'Wahlurne: Fakultät für Physik und Astronomie': const LatLng(51.445032, 7.26556),
    'Wahlurne: Institut für Arbeitswissenschaften (IAW)': const LatLng(51.445032, 7.26556),
    'Wahlurne: Institut für Neuroinformatik (INI)': const LatLng(51.445032, 7.26556),

    'Wahlurne: Fakultät für Informatik': const LatLng(51.444993, 7.258908),
    'Wahlurne: Medizinische Fakultät': const LatLng(51.444993, 7.258908),
    'Wahlurne: sonstigen Einrichtungen': const LatLng(51.444993, 7.258908),

    'Wahlurne: Evangelisch-Theologischen Fakultät': const LatLng(51.443491, 7.25955),
    'Wahlurne: Katholisch-Theologischen Fakultät': const LatLng(51.443491, 7.25955),
    'Wahlurne: Centrum für Religionswissenschaftliche Studien (CERES)': const LatLng(51.443491, 7.25955),
    'Wahlurne: Fakultät für Philosophie und Erziehungswissenschaften': const LatLng(51.443491, 7.25955),
    'Wahlurne: Fakultät für Geschichtswissenschaft': const LatLng(51.443491, 7.25955),

    'Wahlurne: Fakultät für Philologie': const LatLng(51.443106, 7.25845),
    'Wahlurne: Fakultät für Ostasienwissenschaften': const LatLng(51.443106, 7.25845),
    'Wahlurne: Institut für Entwicklungsforschung und Entwicklungspolitik (IEE)': const LatLng(51.443106, 7.25845),

    'Wahlurne: Juristischen Fakultät': const LatLng(51.44226, 7.256181),
    'Wahlurne: Institut für Friedenssicherungsrecht und Humanitäres Völkerrecht (IFHV)':
        const LatLng(51.44226, 7.256181),
    'Wahlurne: Fakultät für Wirtschaftswissenschaft': const LatLng(51.44226, 7.256181),
    'Wahlurne: Fakultät für Sozialwissenschaft': const LatLng(51.44226, 7.256181),

    'Wahlurne: Fakultät für Sportwissenschaft': const LatLng(51.446911, 7.246478),
    'Wahlurne: Studienkolleg': const LatLng(51.446911, 7.246478),
*/
  };

  List<String> suggestions = [];
  bool showCurrentLocation = false;

  @override
  void initState() {
    super.initState();
    print("1");
    _getLocation();
    print("2");
  }

  Future<void> _getLocation() async {
    try {
      waypoints = [];
      print("663");
      final Location location = Location();
      print("664");
      final LocationData currentLocation2 = await location.getLocation();
      print("665");
      setState(() {
        currentLocation = currentLocation2;
        showCurrentLocation = true;
      });
      print("666");
    } catch (e) {
      print('Error getting location: $e');
    }
  }

  Future<void> _getShortestPath(LatLng start, LatLng end) async {
    const String apiUrl = 'https://osrm.app.asta-bochum.de/route/v1/';
    const String profile = 'walking';
    final String url =
        '$apiUrl$profile/${start.longitude},${start.latitude};${end.longitude},${end.latitude}?overview=false&alternatives=false&steps=true';

    setState(() {
      waypoints = [];
    });

    try {
      final http.Response response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        final List<LatLng> newWaypoints = [];

        final List<dynamic> routes = data['routes'];
        if (routes.isNotEmpty) {
          final List<dynamic> legs = routes[0]['legs'];
          for (final leg in legs) {
            final List<dynamic> steps = leg['steps'];
            for (final step in steps) {
              final String geometry = step['geometry'];
              final List<LatLng> coordinates = PolylinePoints()
                  .decodePolyline(geometry)
                  .map((e) => LatLng(e.latitude, e.longitude))
                  .toList();
              newWaypoints.addAll(coordinates);
            }
          }
        }

        setState(() {
          waypoints = newWaypoints;
          _focusNode.unfocus();
        });

        _searchController.text = suggestions.first;
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  LatLng? symbolPosition;
  void _placeSymbol(String locationKey) {
    if (predefinedLocations.containsKey(locationKey)) {
      setState(() {
        symbolPosition = predefinedLocations[locationKey];
        print("Position aktualisiert!");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    TileLayer buildTileLayer() {
      try {
        return TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
        );
      } catch (e) {
        print('An exception occurred: $e');

        return TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
        );
      }
    }

    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            FlutterMap(
              options: MapOptions(
                initialCenter: currentLocation != null
                    ? LatLng(
                        currentLocation!.latitude!,
                        currentLocation!.longitude!,
                      )
                    : const LatLng(51.442887, 7.262413),
                initialZoom: 15,
              ),
              children: [
                buildTileLayer(),
                if (waypoints.isNotEmpty)
                  PolylineLayer(
                    polylines: [
                      Polyline(
                        points: waypoints,
                        color: const Color.fromARGB(169, 33, 149, 243),
                        strokeWidth: 3,
                      ),
                    ],
                  ),
                if (showCurrentLocation)
                  CurrentLocationLayer(
                    style: LocationMarkerStyle(
                      marker: const DefaultLocationMarker(
                        color: Color.fromARGB(255, 255, 255, 255),
                        child: Icon(
                          Icons.person,
                          color: Colors.blue,
                        ),
                      ),
                      markerSize: const Size.square(40),
                      accuracyCircleColor:
                          const Color.fromARGB(255, 113, 143, 243)
                              .withOpacity(0.1),
                      headingSectorColor:
                          const Color.fromARGB(255, 118, 221, 247)
                              .withOpacity(0.8),
                      headingSectorRadius: 120,
                    ),
                    moveAnimationDuration: Duration.zero,
                  ),
                MarkerLayer(
                  markers: [
                    if (symbolPosition != null)
                      Marker(
                        width: 50,
                        height: 50,
                        point: symbolPosition!,
                        rotate: true,
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.location_on,
                          color: Color.fromARGB(255, 0, 174, 255),
                          size: 20,
                        ),
                      ),
                  ],
                ),
              ],
            ),
            Positioned(
              top: 30,
              left: 10,
              right: 10,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 20, 20, 39),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Autocomplete<String>(
                        optionsBuilder: (TextEditingValue textEditingValue) {
                          return predefinedLocations.keys.where(
                            (String option) => option
                                .toLowerCase()
                                .contains(textEditingValue.text.toLowerCase()),
                          );
                        },
                        onSelected: (String selectedOption) {
                          print("222");
                          _searchController.text = selectedOption;
                          _placeSymbol(selectedOption);
                          try {
                            final LatLng startLocation = LatLng(
                              currentLocation!.latitude!,
                              currentLocation!.longitude!,
                            );
                            final LatLng endLocation =
                                predefinedLocations[selectedOption]!;
                            _getShortestPath(startLocation, endLocation);
                            setState(() {
                              showCurrentLocation = true;
                            });
                          } catch (e) {
                            print("Error");
                          }
                        },
                        optionsViewBuilder: (BuildContext context,
                            AutocompleteOnSelected<String> onSelected,
                            Iterable<String> options) {
                          final int itemCount = options.length;
                          final double containerHeight = itemCount * 80.0;
                          return Align(
                            alignment: Alignment.topLeft,
                            child: Container(
                              constraints: BoxConstraints(
                                maxWidth: 300,
                                maxHeight: containerHeight,
                              ),
                              child: Material(
                                elevation: 4,
                                child: ListView(
                                  children: options
                                      .map(
                                        (String option) => GestureDetector(
                                          onTap: () {
                                            onSelected(option);
                                          },
                                          child: ListTile(
                                            title: Text(option),
                                          ),
                                        ),
                                      )
                                      .toList(),
                                ),
                              ),
                            ),
                          );
                        },
                        fieldViewBuilder: (
                          BuildContext context,
                          TextEditingController textEditingController,
                          FocusNode focusNode,
                          VoidCallback onFieldSubmitted,
                        ) {
                          _focusNode = focusNode;

                          return TextField(
                            controller: textEditingController,
                            focusNode: focusNode,
                            decoration: const InputDecoration(
                              hintText: 'Search locations',
                              hintStyle: TextStyle(
                                color: Color.fromARGB(255, 255, 252, 252),
                              ),
                            ),
                            onChanged: (value) {
                              //_updateSuggestions(value);
                            },
                          );
                        },
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                      },
                      icon: const Icon(Icons.search),
                      color: Colors.blue,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => NewPage()),
            );
          },
          backgroundColor: const Color.fromARGB(255, 20, 20, 39),
          child: const Icon(
            Icons.door_front_door_outlined,
            color: Colors.white,
          ),
        ));
  }
}

//-----------------------------------------------------------------------------------------------------------

class NewPage extends StatefulWidget {
  @override
  _NewPageState createState() => _NewPageState();
}

class _NewPageState extends State<NewPage> {
  @override
  void initState() {
    super.initState();

    graph.keys.forEach((key) {
      final Map x = {};
      for (var i = 0; i < graph[key]?['Connections'].length; i++) {
        final (y, z) = graph[key]?['Connections'][i];
        x[y] = z;
      }
      testkarte[key] = x;
    });
    log(testkarte.toString());
    fill();
  }

  List<Uint8List> _images = [];
  List<List<Offset>> _pointsList = [];
  int _currentIndex = 0;
  Map testkarte = {};
  var from = ('SH', '0', 'Haupteingang');
  var to = ('SH', '0', 'Kultur-Cafe');

  void _drawPoint(img.Image image, Offset point, img.Color color, int radius) {
    int centerX = point.dx.toInt();
    int centerY = point.dy.toInt();
    int x = radius;
    int y = 0;
    int radiusError = 1 - x;

    while (x >= y) {
      for (int i = -x; i <= x; i++) {
        image.setPixel(centerX + i, centerY + y, color);
        image.setPixel(centerX + i, centerY - y, color);
      }
      for (int i = -y; i <= y; i++) {
        image.setPixel(centerX + i, centerY + x, color);
        image.setPixel(centerX + i, centerY - x, color);
      }
      y++;

      if (radiusError < 0) {
        radiusError += 2 * y + 1;
      } else {
        x--;
        radiusError += 2 * (y - x + 1);
      }
    }
  }

  void _drawLine(
      img.Image image, Offset p1, Offset p2, img.Color color, int thickness) {
    final double dx = p2.dx - p1.dx;
    final double dy = p2.dy - p1.dy;
    final double length = dx.abs() > dy.abs() ? dx.abs() : dy.abs();

    final double xIncrement = dx / length;
    final double yIncrement = dy / length;

    for (int i = 0; i < length; i++) {
      for (int j = 0; j < thickness; j++) {
        final int x = (p1.dx + i * xIncrement).toInt();
        final int y = (p1.dy + i * yIncrement).toInt();

        for (int k = 0; k < thickness; k++) {
          image.setPixel(x + k, y + j, color);
        }
      }
    }
  }

  Future<void> _loadImages(List<dynamic> shortestPath) async {
    final List<String> filenames = [];
    final List<Uint8List> loadedImages = [];

    for (int i = 0; i < shortestPath.length; i++) {
      final (first1, first2, first3) = shortestPath[i];
      final String filename = '$first1$first2.jpg';
      if (!filenames.contains(filename)) {
        filenames.add(filename);
        print(filename);
      }
    }
    print("Punkt2");
    print(filenames);

    for (int i = 0; i < filenames.length; i++) {
      setState(() {
        _pointsList.add([]);
      });
    }

    print("Punkt 3:");
    print(_pointsList);

    for (int i = 0; i < shortestPath.length; i++) {
      final (x1, x2, x3) = shortestPath[i];
      final String name = '$x1$x2.jpg';

      for (int j = 0; j < filenames.length; j++) {
        if (filenames[j] == name) {
          final dynamic key = shortestPath[i];
          final List<int> coordinates = graph[key]!["Coordinates"];
          final Offset offset =
              Offset(coordinates[0].toDouble(), coordinates[1].toDouble());
          _pointsList[j].add(offset);
        }
      }
    }

    print("Punkt 4:");
    print(_pointsList);

    for (int i = 0; i < filenames.length; i++) {
      print("i");
      final ByteData data = await DefaultAssetBundle.of(context)
          .load("lib/pages/pathfinder/maps/${filenames[i]}");
      final Uint8List bytes = data.buffer.asUint8List();
      final img.Image image = img.decodeImage(bytes)!;

      for (int j = 0; j < _pointsList[i].length - 1; j++) {
        print("j");
        _drawLine(image, _pointsList[i][j], _pointsList[i][j + 1],
            img.ColorRgb8(0, 255, 255), 10);
      }

      _drawPoint(image, _pointsList[i].last, img.ColorRgb8(255, 0, 0), 20);

      final Uint8List modifiedImage = Uint8List.fromList(img.encodePng(image));

      _images.add(modifiedImage);
    }

    setState(() {
      _images.addAll(loadedImages);
    });

    print("Final List: ");
    print(filenames);
    print(_pointsList);
  }

  List<dynamic> test(Map karte) {
    final testweg = Dijkstra.findPathFromGraph(karte, from, to);
    print("Test");
    print(testweg);

    return testweg;
  }

  Future<List> yourFunction(Map karte) async {
    print('New page opened');

    final List<dynamic> shortestPath = test(karte);
    print("Punkt 1:");
    print(shortestPath);
    await _loadImages(shortestPath);
    print("Fertig!");
    print(_images);
    return (_images);
  }

  final TransformationController _controller = TransformationController();

  //-------------------------------------------------------------------------

  final TextEditingController _startController = TextEditingController();
  final TextEditingController _zielController = TextEditingController();

  Future<void> _validateAndPerformAction() async {
    final String startText = _startController.text;
    final String zielText = _zielController.text;

    if (startText.isNotEmpty && zielText.isNotEmpty) {
      print("Extract");
      final List<String> components = startText.split(" ");
      final String building = components[0];
      final String levelAndRoom = components[1];
      final List<String> levelAndRoomComponents = levelAndRoom.split("/");
      final String level = levelAndRoomComponents[0];
      final String room = levelAndRoomComponents[1];
      final start = (building, level, room);
      print(start);

      final List<String> components2 = zielText.split(" ");
      final String building2 = components2[0];
      final String levelAndRoom2 = components2[1];
      final List<String> levelAndRoomComponents2 = levelAndRoom2.split("/");
      final String level2 = levelAndRoomComponents2[0];
      final String room2 = levelAndRoomComponents2[1];
      final ziel = (building2, level2, room2);
      print(ziel);

      setState(() {
        from = start;
        to = ziel;
        _images = [];
        _pointsList = [];
        _currentIndex = 0;
      });
      final List<Uint8List> _images2 =
          await yourFunction(testkarte) as List<Uint8List>;
      print(_images);
      print(_pointsList);
      print(_currentIndex);
      print(testkarte);
      setState(() {
        _images = _images2;
      });
    } else {
      print('Both fields must be filled.');
    }
  }

  List<String> suggestions = [];
  void fill() {
    print("Filling");
    testkarte.keys.forEach((key) {
      final (x1, x2, x3) = key;
      final x4 = "$x1 $x2/$x3";
      suggestions.add(x4);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gebäude Interne Navigation'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 5, 10, 2),
            child: Autocomplete<String>(
              optionsBuilder: (TextEditingValue textEditingValue) {
                if (textEditingValue.text.isEmpty) {
                  return suggestions;
                }
                return suggestions.where((String option) {
                  return option
                      .toLowerCase()
                      .contains(textEditingValue.text.toLowerCase());
                });
              },
              onSelected: (String selection) {
                _startController.text = selection;
              },
              fieldViewBuilder: (BuildContext context,
                  TextEditingController textEditingController,
                  FocusNode focusNode,
                  VoidCallback onFieldSubmitted) {
                _startController.text = textEditingController.text;
                return TextField(
                  controller: textEditingController,
                  focusNode: focusNode,
                  onSubmitted: (value) {
                    onFieldSubmitted();
                    _validateAndPerformAction();
                  },
                  decoration: const InputDecoration(
                    hintText: 'Start:       zB. SSC 0/112',
                    border: OutlineInputBorder(),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 2, 10, 5),
            child: Autocomplete<String>(
              optionsBuilder: (TextEditingValue textEditingValue) {
                if (textEditingValue.text.isEmpty) {
                  return suggestions;
                }
                return suggestions.where((String option) {
                  return option
                      .toLowerCase()
                      .contains(textEditingValue.text.toLowerCase());
                });
              },
              onSelected: (String selection) {
                _zielController.text = selection;
              },
              fieldViewBuilder: (BuildContext context,
                  TextEditingController textEditingController,
                  FocusNode focusNode,
                  VoidCallback onFieldSubmitted) {
                _zielController.text = textEditingController.text;
                return TextField(
                  controller: textEditingController,
                  focusNode: focusNode,
                  onSubmitted: (value) {
                    onFieldSubmitted();
                    _validateAndPerformAction();
                  },
                  decoration: const InputDecoration(
                    hintText: 'Ziel:         zB. SSC 1/432',
                    border: OutlineInputBorder(),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: GestureDetector(
              onScaleStart: (details) {
                _controller.value = Matrix4.identity();
              },
              onHorizontalDragUpdate: (details) {
                if (_controller.value.getMaxScaleOnAxis() == 1.0) {
                  if (details.delta.dx > 0) {
                    // Swiped right
                    setState(() {
                      if (_currentIndex > 0) {
                        _currentIndex--;
                        _controller.value = Matrix4.identity();
                        print(_currentIndex);
                      }
                    });
                  } else if (details.delta.dx < 0) {
                    setState(() {
                      if (_currentIndex < _images.length - 1) {
                        _currentIndex++;
                        _controller.value = Matrix4.identity();
                        print(_currentIndex);
                      }
                    });
                  }
                }
              },
              child: _images.isNotEmpty
                  ? InteractiveViewer(
                      transformationController: _controller,
                      boundaryMargin: const EdgeInsets.all(20),
                      minScale: 0.1,
                      maxScale: 4,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        child: Image.memory(_images[_currentIndex],
                            fit: BoxFit.contain),
                      ),
                    )
                  : const Center(
                      child: Icon(
                        Icons.search, // Choose the maze icon you prefer
                        size: 150, // Adjust the size as needed
                        color: Colors.grey, // Adjust the color as needed
                      ),
                    ),
            ),
          ),
        ],
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            backgroundColor: Color.fromARGB(255, 216, 216, 216),
            onPressed: () {
              setState(() {
                if (_currentIndex > 0) {
                  _currentIndex = _currentIndex - 1;
                  print(_currentIndex);
                }
              });
            },
            child: const Icon(Icons.arrow_back),
          ),
          const SizedBox(width: 10),
          FloatingActionButton(
            backgroundColor: Color.fromARGB(255, 216, 216, 216),
            onPressed: () async {
              setState(() {
                if (_currentIndex < _images.length - 1) {
                  _currentIndex = _currentIndex + 1;
                  print(_currentIndex);
                }
              });
            },
            child: const Icon(Icons.arrow_forward),
          ),
        ],
      ),
    );
  }
}
