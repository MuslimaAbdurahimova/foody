import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class StreamProductPage extends StatefulWidget {
  const StreamProductPage({Key? key}) : super(key: key);

  @override
  State<StreamProductPage> createState() => _StreamProductPageState();
}

class _StreamProductPageState extends State<StreamProductPage> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  check() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      print("mobile");
    } else if (connectivityResult == ConnectivityResult.wifi) {
      print("wifi");
    }

    Connectivity().checkConnectivity().asStream().listen((event) {
      if (event == ConnectivityResult.mobile) {
        print("mobile");
      } else if (event == ConnectivityResult.wifi) {
        print("wifi");
      }else{
        print("no internet");
      }
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Products"),
      ),
      body: StreamBuilder(
          stream: Connectivity().onConnectivityChanged,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Center(child: Text(snapshot.data.toString()));
              // return ListView.builder(
              //     shrinkWrap: true,
              //     itemCount: snapshot.data?.docs.length ?? 0,
              //     itemBuilder: (context, index) {
              //       return Container(
              //         margin: EdgeInsets.all(16),
              //         width: double.infinity,
              //         color: Colors.pinkAccent,
              //         child: Row(
              //           children: [
              //             snapshot.data?.docs[index]["image"] == null
              //                 ? const SizedBox.shrink()
              //                 : Image.network(
              //                     snapshot.data?.docs[index]["image"] ?? "",
              //                     height: 64,
              //                     width: 64,
              //                   ),
              //             Expanded(
              //               child: Column(
              //                 children: [
              //                   Text(snapshot.data?.docs[index]["name"] ?? ""),
              //                   Text(snapshot.data?.docs[index]["desc"] ?? ""),
              //                 ],
              //               ),
              //             ),
              //             const Spacer(),
              //             Text(snapshot.data!.docs[index]["price"].toString()),
              //             // IconButton(
              //             //     onPressed: () {
              //             //       // event.changeLike(index);
              //             //     },
              //             //     icon: (state.listOfProduct[index].isLike)
              //             //         ? Icon(Icons.favorite)
              //             //         : Icon(Icons.favorite_border))
              //           ],
              //         ),
              //       );
              //     });
            } else if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error.toString()}"));
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }),
    );
  }
}