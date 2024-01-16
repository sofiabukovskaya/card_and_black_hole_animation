import 'package:black_hole_animation/black_hole_clipper.dart';
import 'package:black_hole_animation/hello_world_card.dart';
import 'package:flutter/material.dart';

class CardHiddenAnimationPage extends StatefulWidget {
  const CardHiddenAnimationPage({Key? key}) : super(key: key);

  @override
  State<CardHiddenAnimationPage> createState() =>
      _CardHiddenAnimationPageState();
}

class _CardHiddenAnimationPageState extends State<CardHiddenAnimationPage>
    with TickerProviderStateMixin {
  ///animation black hole stuff
  late final holeSizeTween = Tween<double>(
    begin: 0,
    end: 1.5 * cardSize,
  );
  late final holeAnimationController = AnimationController(
    vsync: this,
    duration: const Duration(
      milliseconds: 300,
    ),
  );
  double get holeSize => holeSizeTween.evaluate(holeAnimationController);

  ///animation card stuff
  late final cardOffsetAnimationController = AnimationController(vsync: this, duration: const Duration(seconds: 1,),);
  late final cardOffsetTween = Tween<double>(begin: 0, end: cardSize * 2,).chain(CurveTween(curve: Curves.easeInBack,),);
  late final cardRotationTween = Tween<double>(begin: 0, end: 0.5 ).chain(CurveTween(curve: Curves.easeInBack,),);
  late final cardElevationTween = Tween<double>(end: 20, begin: 2);

  double get cardOffset => cardOffsetTween.evaluate(cardOffsetAnimationController);

  double get cardRotation => cardRotationTween.evaluate(cardOffsetAnimationController);

  double get cardElevation => cardElevationTween.evaluate(cardOffsetAnimationController);

  final cardSize = 150;

  @override
  void dispose() {
    holeAnimationController.dispose();
    cardOffsetAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            onPressed: () async {
              await holeAnimationController.forward();
              await cardOffsetAnimationController.forward();

              Future.delayed(
                const Duration(milliseconds: 300),
                () => holeAnimationController.reverse(),
              );
            },
            child: const Icon(Icons.remove),
          ),
          const SizedBox(
            width: 20,
          ),
          FloatingActionButton(
            onPressed: () {
              cardOffsetAnimationController.reverse();
              holeAnimationController.reverse();
            },
            child: const Icon(Icons.add),
          ),
        ],
      ),
      body: Center(
        child: AnimatedBuilder(
          animation: CurvedAnimation(
            parent: holeAnimationController,
            curve: Curves.linear,
          ),
          builder: (BuildContext context, Widget? child) {
            return SizedBox(
              height: cardSize * 1.25,
              width: double.infinity,
              child: ClipPath(
                clipper: BlackHoleClipper(),
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  clipBehavior: Clip.none,
                  children: [
                    SizedBox(
                      width: holeSize,
                      child: Image.asset(
                        'assets/hole.png',
                        fit: BoxFit.fill,
                      ),
                    ),
                    AnimatedBuilder(
                      animation: CurvedAnimation(
                        parent: cardOffsetAnimationController,
                        curve: Curves.linear,
                      ),
                      builder: (BuildContext context, Widget? child) {  return Positioned(
                        child: Center(
                          child: Transform.translate(
                            offset:  Offset(0, cardOffset),
                            child: Transform.rotate(
                              angle: cardRotation,
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: HelloWorldCard(
                                  size: cardSize.toDouble(),
                                  elevation: cardElevation,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );},
                
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
