import 'package:flutter/material.dart';
import 'package:flutter_mastering_part2/pages/album.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<Album> getAlbum() async {
    // pura-pura delay
    final response = await http.get(
      Uri.parse('http://jsonplaceholder.typicode.com/albums/2'),
    );

    if (response.statusCode == 200) {
      return Album.fromJson(response.body);
    } else {
      throw Exception('${response.statusCode}');
    }
  }

  late Future<Album> futureAlbum;

  // Controller
  TextEditingController titleController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    futureAlbum = getAlbum();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          FutureBuilder<Album>(
            future: futureAlbum,
            builder: (context, snapshot) {
              debugPrint('${snapshot.data}');
              if (snapshot.hasData) {
                return Center(child: Text(snapshot.data!.title));
              } else if (snapshot.hasError) {
                return Center(child: Text('${snapshot.error}'));
              }

              return const CircularProgressIndicator();
            },
          ),
          Divider(),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                controller: titleController,
                decoration: const InputDecoration(hintText: 'Enter Title'),
              ),
              ElevatedButton(
                onPressed: () {
                  // debugPrint(titleController.text);
                  if (titleController.text.isNotEmpty) {
                    setState(() {
                      futureAlbum = createAlbum(titleController.text);
                    });
                  } else {
                    throw Exception('Title is empty');
                  }
                },
                child: const Text('Create Data'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
