import 'package:flutter/material.dart';
import 'package:webfeed/webfeed.dart';
import 'package:http/http.dart' as http;

void main() => runApp(const MaterialApp(
  home: ThisWillWork(),
));

class ThisWillWork extends StatefulWidget {
  const ThisWillWork({Key? key}) : super(key: key);
  @override
  State<ThisWillWork> createState() => _ThisWillWorkState();
}

class _ThisWillWorkState extends State<ThisWillWork> {
  late Future<RssFeed> result;
  Future<RssFeed> giver() async {
    print("hi arun");
    var response =
    await http.get(Uri.parse("https://www.hnrss.org/jobs"));
    //await http.get(Uri.parse("https://www.espncricinfo.com/rss/content/story/feeds/0.xml"));
    print(response.statusCode);
    var overhead = RssFeed.parse(response.body);
    print(overhead);
    return overhead;
  }
  @override
  void initState() {
    super.initState();
    result=giver();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jobs'),
      ),
      body: FutureBuilder<RssFeed?>(
        future: result,
        builder: (context, snapshot){
          if(snapshot.hasError){
            return Text("${snapshot.error}");
          }
          else if(snapshot.connectionState==ConnectionState.waiting){
            return const Center(child: CircularProgressIndicator());
          }
          else if(snapshot.hasData) {
            var feed = snapshot.data!;
            var items = feed.items;
            return ListView.builder(
              itemCount: items?.length,
              itemBuilder: (context, index) {
                var item=items![index];
                return ListTile(
                  title: Text(item.title!),
                  subtitle: Text("${item.pubDate!}"),
                );
              },
            );
          }
          return Container(
            color: Colors.green,
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          result=giver();
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
