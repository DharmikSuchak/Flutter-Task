import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'GetSampleApi.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blueGrey),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<GetSampleApi>? apiList;

  @override
  void initState() {
    super.initState();
    getApiData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Flutter Internship Assignment"),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          if(apiList != null)
            getList(),
        ],
      ),
    );
  }

  Widget getList() {
    return Expanded(
      child: ListView.builder(
        itemCount: apiList != null ? apiList!.length : 0,
        itemBuilder: (BuildContext context, int index) {
          return buildCard(apiList![index]);
        },
      ),
    );
  }

  Widget buildCard(GetSampleApi apiData) {
    Color cardColor = getColorForDateDifference(apiData.dateOfJoining);

    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: Colors.grey[300]!),
      ),
      color: cardColor,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                apiData.name ?? '',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(width: 10),
            const Icon(
              Icons.person,
              size: 20,
              color: Colors.blue,
            ),
          ],
        ),
      ),
    );
  }

  Color getColorForDateDifference(String? dateOfJoining) {
    if (dateOfJoining != null) {
      DateTime? joiningDate = DateTime.tryParse(dateOfJoining);
      if (joiningDate != null) {
        DateTime currentDate = DateTime.now();
        int differenceInDays = currentDate.difference(joiningDate).inDays;

        if (differenceInDays >= 0 && differenceInDays <= 365) {
          return Colors.red;
        } else if (differenceInDays > 365 && differenceInDays <= 5 * 365) {
          return Colors.white;
        } else {
          return Colors.green;
        }
      }
    }
    return Colors.white; // Default color
  }

  Future<void> getApiData() async {
    try {
      String url = "http://192.168.0.105:3000/employees"; //change ipaddress
      var result = await http.get(Uri.parse(url));

      if (result.statusCode == 200) {
        List<dynamic> data = jsonDecode(result.body);
        apiList = data
            .map((item) => GetSampleApi.fromJson(item))
            .toList()
            .cast<GetSampleApi>();
        setState(() {});
      } else {
        print("Failed to load data: ${result.statusCode}");

      }
    } catch (e) {
      print("Error fetching data: $e");
    }
  }
}
