import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shuerte/providers/shuerte.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // double rpx=MediaQuery.of(context).size.width/750;

    return MaterialApp(
      title: "舒尔特方格 ",
      home: AllParent(),
    );
  }
}

class AllParent extends StatefulWidget {
  AllParent({Key key}) : super(key: key);

  _AllParentState createState() => _AllParentState();
}

class _AllParentState extends State<AllParent> {
  var table = AnimContainer();
  var timer = CountTimer();
  reset() {}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("舒尔特方格"),
        ),
        body: MultiProvider(
            providers: [
              ChangeNotifierProvider(
                builder: (context) => MainProvider(),
              )
            ],
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 40,
                ),
                SizedBox(
                  height: 450,
                  child: table,
                ),
                timer
              ],
            )));
  }
}

class CountTimer extends StatefulWidget {
  CountTimer({Key key}) : super(key: key);

  _CountTimerState createState() => _CountTimerState();
}

class _CountTimerState extends State<CountTimer> {
  Timer time;
  double totalTime = 0;
  bool ifStarted = false;
  @override
  void initState() {
    super.initState();
    
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<MainProvider>(context);

    return SizedBox(
        height: 200,
        child: Column(
          children: [
            Expanded(
                flex: 5,
                child: Center(
                  child: Text(
                    "${provider.totalTime.toStringAsFixed(1)}",
                    style: TextStyle(fontSize: 20),
                  ),
                )),
            Container(
                child: Flexible(
              flex: 2,
              child: MaterialButton(
                // padding: EdgeInsets.fromLTRB(40, 0, 40, 0),
                splashColor: Colors.transparent,
                color: Colors.blueAccent,
                onPressed: () {
                  provider.changeCount();
                },
                child: Text(
                  provider.count==16 ? "25格" : "16格",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            )),
            Container(
                child: Flexible(
              flex: 2,
              child: MaterialButton(
                // padding: EdgeInsets.fromLTRB(40, 0, 40, 0),
                splashColor: Colors.transparent,
                color: Colors.blueAccent,
                onPressed: () {
                  provider.resetValue();
                },
                child: Text(
                  "换一题",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            )),
          ],
        ));
  }
}

class AnimContainer extends StatefulWidget {
  AnimContainer({Key key}) : super(key: key);

  _AnimContainerState createState() => _AnimContainerState();
}

class _AnimContainerState extends State<AnimContainer>
    with TickerProviderStateMixin {
  List<Color> conColor = List<Color>();
  List<int> data = List<int>();
  List<int> curSel = List<int>();
  // int count=25;
  // AnimationController animController;

  List<Animation<Color>> animation;
  List<AnimationController> controller;
  @override
  void initState() {
    super.initState();
    animation = List<Animation<Color>>();
    controller = List<AnimationController>();
    curSel = List<int>();
    // for (int i = 0; i < count; i++) {
    //   controller.add(AnimationController(
    //       duration: const Duration(milliseconds: 500), vsync: this));
    //   animation.add(ColorTween(
    //     begin: Colors.white,
    //     end: Colors.purpleAccent,
    //   ).animate(controller[i])
    //     ..addListener(() {
    //       setState(() {});
    //     }));
    // }
    // List.generate(16, (i) {
    //   conColor.add(Colors.white);
    // });

    // List.generate(16, (i) => data.add(i + 1));
    // data.shuffle();
  }

  // void tapBox(i) {
  //   int prevValue = curSel.length > 0 ? curSel.last : 0;
  //   if (data[i] - prevValue != 1) {
  //     animation[i] = ColorTween(
  //       begin: Colors.white,
  //       end: Colors.red,
  //     ).animate(controller[i])
  //       ..addListener(() {
  //         setState(() {});
  //       });
  //   } else {
  //     curSel.add(data[i]);
  //     setState(() {
  //       curSel = curSel;
  //     });
  //   }
  //   controller[i].forward(from: 0).then((_) => controller[i].reverse());
  // }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<MainProvider>(context);
    int count=provider.count;
    for (int i = 0; i < count; i++) {
      controller.add(AnimationController(
          duration: const Duration(milliseconds: 500), vsync: this));
      animation.add(ColorTween(
        begin: Colors.white,
        end: Colors.purpleAccent,
      ).animate(controller[i])
        ..addListener(() {
          setState(() {});
        }));
    }
    provider.animation = animation;
    provider.controller = controller;
    return GridView.count(
      crossAxisCount: sqrt(count).round(),
      children: List.generate(
          count,
          (i) => Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: provider.animation[i].value, border: Border.all(width: 1)),
              child: Container(
                  child: FlatButton(
                padding: EdgeInsets.all(count==25? 10:20),
                child: Text(
                  "${provider.data[i]}",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  provider.tapCell(i);
                },
              )))).toList(),
    );
  }
}
