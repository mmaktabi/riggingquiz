import 'package:flutter/material.dart';
import 'package:rigging_quiz/utils/constant.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Material App',
      home: Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Musicvisualizer(),
        ),
      ),
    );
  }
}

class Musicvisualizer extends StatefulWidget {
  const Musicvisualizer({super.key});

  @override
  State<Musicvisualizer> createState() => _MusicvisualizerState();
}

class _MusicvisualizerState extends State<Musicvisualizer> {
  List<Color> colors = [
    const Color.fromRGBO(196, 208, 251, 1),
    ColorsHelpers.primaryColor,
    const Color.fromRGBO(196, 208, 251, 1),
    ColorsHelpers.primaryColor
  ];

  List<int> duration = [900, 200, 600, 100, 700];

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List<Widget>.generate(
          15,
          (index) => VisualComponent(
              duration: duration[index % 5], color: colors[index % 4])),
    );
  }
}

class VisualComponent extends StatefulWidget {
  const VisualComponent(
      {super.key, required this.duration, required this.color});

  final int duration;
  final Color color;

  @override
  VisualComponentState createState() => VisualComponentState();
}

class VisualComponentState extends State<VisualComponent>
    with SingleTickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController animController;

  @override
  void initState() {
    super.initState();
    animController = AnimationController(
        duration: Duration(milliseconds: widget.duration), vsync: this);
    final curvedAnimation =
        CurvedAnimation(parent: animController, curve: Curves.slowMiddle);

    animation = Tween<double>(begin: 0, end: 100).animate(curvedAnimation)
      ..addListener(() {
        setState(() {});
      });
    animController.repeat(reverse: true);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 5,
        decoration: BoxDecoration(
            color: widget.color, borderRadius: BorderRadius.circular(5)),
        height: animation.value);
  }
}
