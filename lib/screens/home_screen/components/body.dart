import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_learning_dio/utils/helper.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_learning_dio/screens/home_screen/components/background.dart';

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final imageUrl = "https://unsplash.com/photos/iEJVyyevw-U/download?force=true";
  bool downloading = false;
  var progressString = "0%";

  Future<void> downloadFile() async {
    Dio dio = Dio();
    progressString = "0%";

    try {
      var dir = await getApplicationDocumentsDirectory();
      print("Directory found ${dir.path}/myimage.jpg");
      Helper.toast(context, "Directory found");

      setState(() {
        downloading = true;
      });
      await dio.download(
        imageUrl,
        "${dir.path}/myimage.jpg",
        onReceiveProgress: (rec, total) {
          print("Rec: $rec , Total: $total");

          setState(() {
            progressString = ((rec / total) * 100).toStringAsFixed(0) + "%";
          });
        },
      );
    } catch (e) {
      setState(() {
        downloading = false;
      });
      print("Something went wrong");
      Helper.toast(context, "Something went wrong");
      print(e);
    }

    setState(() {
      downloading = false;
      progressString = "Completed";
      Helper.toast(context, "Download Completed", 4, Colors.green);
    });
    print("Download completed");

  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Background(
      child: Container(
        height: size.height,
        width: double.infinity,
        child: Stack(
          children: [
            Center(
              child: downloading
                  ? Container(
                      height: 120.0,
                      width: 200.0,
                      child: Card(
                        color: Colors.black,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            CircularProgressIndicator(),
                            SizedBox(
                              height: 20.0,
                            ),
                            Text(
                              "Downloading File: $progressString",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  : Text("No Data"),
            ),
            Positioned(
              bottom: 16,
              right: 8,
              child: ElevatedButton(
                onPressed: () {
                  Helper.toast(context, "starting...");
                  downloadFile();
                },
                child: Icon(Icons.download),
                style: ElevatedButton.styleFrom(
                  shape: CircleBorder(),
                  padding: EdgeInsets.all(16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
