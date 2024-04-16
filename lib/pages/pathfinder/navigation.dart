/*

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

//--------------------------------------------------------------------

class _MyHomePageState extends State<MyHomePage> {
  List<Uint8List> _images = [];
  List<List<Offset>> _pointsList = [];

  int _currentIndex = 0;

  final Map<dynamic, Map<String, dynamic>> graph = {
    ('BuildingA', 'Level2', "Room0"): {
      'Name': 'Room0',
      'Type': 'Room',
      'Coordinates': [1375, 50],
      'GPS': [40.7128, -74.0060],
      'Connections': [
        (('BuildingA', 'Level1', 2), 10),
        (('BuildingA', 'Level1', 3), 15),
        (('BuildingA', 'Level1', 4), 20),
      ]
    },
    ('BuildingA', 'Level1', "Room1"): {
      'Name': 'Room1',
      'Type': 'Room',
      'Coordinates': [2500, 20],
      'GPS': [40.7128, -74.0060],
      'Connections': [
        (('BuildingA', 'Level1', 2), 10),
        (('BuildingA', 'Level1', 3), 15),
        (('BuildingA', 'Level1', 4), 20),
      ]
    },
    ('BuildingA', 'Level1', "Room2"): {
      'Name': 'Room2',
      'Type': 'Room',
      'Coordinates': [30, 40],
      'GPS': [40.7128, -74.0060],
      'Connections': [
        (('BuildingA', 'Level1', 1), 10),
        (('BuildingA', 'Level1', 3), 5),
        (('BuildingA', 'Level1', 5), 25),
      ]
    },
    ('BuildingA', 'Level1', "Room3"): {
      'Name': 'Room3',
      'Type': 'Room',
      'Coordinates': [50, 60],
      'GPS': [40.7128, -74.0060],
      'Connections': [
        (('BuildingA', 'Level1', 1), 15),
        (('BuildingA', 'Level1', 2), 5),
        (('BuildingA', 'Level1', 4), 10),
        (('BuildingA', 'Level1', 5), 30),
      ]
    },
    ('BuildingA', 'Level1', "Room4"): {
      'Name': 'Room4',
      'Type': 'Room',
      'Coordinates': [70, 80],
      'GPS': [40.7128, -74.0060],
      'Connections': [
        (('BuildingA', 'Level1', 1), 20),
        (('BuildingA', 'Level1', 3), 10),
        (('BuildingA', 'Level1', 5), 15),
        (('BuildingA', 'Level1', 6), 35),
      ]
    },
    ('BuildingA', 'Level1', "Room5"): {
      'Name': 'Room5',
      'Type': 'Room',
      'Coordinates': [90, 100],
      'GPS': [40.7128, -74.0060],
      'Connections': [
        (('BuildingA', 'Level1', 2), 25),
        (('BuildingA', 'Level1', 3), 30),
        (('BuildingA', 'Level1', 4), 15),
        (('BuildingA', 'Level1', 6), 40),
      ]
    },
    ('BuildingA', 'Level1', "Room6"): {
      'Name': 'Room6',
      'Type': 'Room',
      'Coordinates': [1000, 1000],
      'GPS': [40.7128, -74.0060],
      'Connections': [
        (('BuildingA', 'Level1', 4), 35),
        (('BuildingA', 'Level1', 5), 40),
      ]
    },
  };

//--------------------------------------------------------------------

  @override
  void initState() {
    super.initState();
    /*
    var (from1, from2, from3) = ('BuildingA', 'Level1', 'Room4');
    var (to1, to2, to3) = ('BuildingA', 'Level1', 'Room1');

    List<dynamic> shortestPath = Dijkstra.findPathFromGraph(
        graph2, (from1, from2, from3), (to1, to2, to3));
    */
    List<dynamic> shortestPath = test();
    print("Punkt 1:");
    print(shortestPath);
    _loadImages(shortestPath);
  }

//--------------------------------------------------------------------

  Future<void> _loadImages(List<dynamic> shortestPath) async {
    List<String> filenames = []; // Add your filenames here

    for (int i = 0; i < shortestPath.length; i++) {
      // 0ten und 1sten Eintrag Tupel
      var (first1, first2, first3) = shortestPath[i];
      String filename = '${first1}${first2}.jpg';
      if (!filenames.contains(filename)) {
        filenames.add(filename);
      }
    }
    print("Punkt2");
    print(filenames);

    //Ergänzung

    for (int i = 0; i < filenames.length; i++) {
      setState(() {
        _pointsList.add([]);
      });
    }

    print("Punkt 3:");
    print(_pointsList);

    for (int i = 0; i < shortestPath.length; i++) {
      var (x1, x2, x3) = shortestPath[i];
      String name = '${x1}${x2}.jpg';

      for (int j = 0; j < filenames.length; j++) {
        if (filenames[j] == name) {
          //dynamic key = ('BuildingA', 'Level1', 1);
          dynamic key = shortestPath[i];
          print(key);
          List<int> coordinates = graph[key]!["Coordinates"];
          Offset offset = Offset(coordinates[0].toDouble(), coordinates[1].toDouble());
          _pointsList[j].add(offset);
        }
      }
    }

    print("Punkt 4:");
    print(_pointsList);

    //Ergänzung
    //Zeichen
    print("Beginn drawing");
    for (int i = 0; i < filenames.length; i++) {
      ByteData data = await DefaultAssetBundle.of(context).load("lib/${filenames[i]}");
      List<int> bytes = data.buffer.asUint8List();
      img.Image image = img.decodeImage(bytes)!;

      // Draw lines on the image
      print(filenames[i]);
      print(_pointsList[i]);
      print(_pointsList[i].length);
      for (int j = 0; j < _pointsList[i].length - 1; j++) {
        _drawLine(
            image, _pointsList[i][j], _pointsList[i][j + 1], img.getColor(57, 255, 20), 5); // Adjust thickness here
        print(j);
      }
      // Convert the modified image to Uint8List
      Uint8List modifiedImage = Uint8List.fromList(img.encodePng(image));

      setState(() {
        _images.add(modifiedImage);
        //print(_images);
      });
    }

    //Zeichen
    print("Fianl List: ");
    print(filenames); //only one name
    print(_pointsList);
  }

//--------------------------------------------------------------------

  List<dynamic> test() {
    //Test

    Map karte = {
      ('BuildingA', 'Level1', 'Room1'): {('BuildingA', 'Level1', 'Room2'): 1},
      ('BuildingA', 'Level1', 'Room2'): {('BuildingA', 'Level1', 'Room3'): 1},
      ('BuildingA', 'Level1', 'Room3'): {('BuildingA', 'Level1', 'Room4'): 1},
      ('BuildingA', 'Level1', 'Room4'): {('BuildingA', 'Level1', 'Room1'): 1},
    };
    var testweg = Dijkstra.findPathFromGraph(karte, ('BuildingA', 'Level1', 'Room1'), ('BuildingA', 'Level1', 'Room4'));
    print("Test");
    print(testweg);

    return testweg;
    //Test
  }

//--------------------------------------------------------------------

  void _drawLine(img.Image image, Offset p1, Offset p2, int color, int thickness) {
    // Calculate delta x and delta y
    double dx = p2.dx - p1.dx;
    double dy = p2.dy - p1.dy;

    // Calculate the length of the line
    double length = dx.abs() > dy.abs() ? dx.abs() : dy.abs();

    // Calculate the increment for each step
    double xIncrement = dx / length;
    double yIncrement = dy / length;

    // Draw multiple lines in parallel to increase thickness
    for (int i = 0; i < length; i++) {
      for (int j = 0; j < thickness; j++) {
        int x = (p1.dx + i * xIncrement).toInt();
        int y = (p1.dy + i * yIncrement).toInt();

        // Draw a pixel at (x, y)
        for (int k = 0; k < thickness; k++) {
          image.setPixel(x + k, y + j, color);
        }
      }
    }
  }

//--------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Editor Demo'),
      ),
      body: _images.isNotEmpty
          ? InteractiveViewer(
              boundaryMargin: EdgeInsets.all(20),
              minScale: 0.1,
              maxScale: 4.0,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Image.memory(_images[_currentIndex], fit: BoxFit.contain),
              ),
            )
          : Center(
              child: CircularProgressIndicator(),
            ), // Display a loading indicator if images are not loaded yet
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              setState(() {
                _currentIndex = (_currentIndex - 1) % _images.length;
                if (_currentIndex < 0) _currentIndex = _images.length - 1;
              });
            },
            child: Icon(Icons.arrow_back),
          ),
          SizedBox(width: 10),
          FloatingActionButton(
            onPressed: () {
              /*List<dynamic> path =
                  dijkstraWithPaths(graph, ('BuildingA', 'Level1', 1), 'Room5');
              print('Shortest Path: $path');
              setState(() {
                _currentIndex = (_currentIndex + 1) % _images.length;
              })*/
              ;
            },
            child: Icon(Icons.arrow_forward),
          ),
        ],
      ),
    );
  }
}
*/