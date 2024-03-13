import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:heaven_of_mt/card/card_church.dart';
import 'dart:math';

import '../../card/card.dart';
import '../game_contents.dart';
import '../gameover/gameover_church.dart';
import '../ready_church.dart';
import 'church_contents.dart';

class ChurchDiscoGame extends StatefulWidget {
  const ChurchDiscoGame({
    super.key,
  });

  @override
  State<ChurchDiscoGame> createState() => _ChurchDiscoGamePageState();
}

class _ChurchDiscoGamePageState extends State<ChurchDiscoGame> {
  FocusNode focusNode = FocusNode();
  int currentCardIndex = 0; // 현재 카드의 인덱스를 저장할 변수
  final CardSwiperController controller = CardSwiperController();
  List<GameCardChurch> cards = []; // cards 변수를 초기화
  final random = Random();
  List<GameContents> randomdisco = [];
  @override
  void initState() {
    super.initState();
    focusNode.requestFocus();
    FirebaseAnalytics.instance.setCurrentScreen(screenName: "교회_디스코");

    // widget.id 값에 따라 cards 변수에 값을 할당

    final churchDiscoIndices = List<int>.generate(churchDisco.length, (i) => i)
      ..shuffle(random);
    randomdisco = churchDiscoIndices
        .sublist(0, 10)
        .map((index) => churchDisco[index])
        .toList();

    cards = randomdisco
        .map((gameContents) =>
            GameCardChurch(gameContents: gameContents, fontSize: 140))
        .toList();
  }

  bool isUndoButtonVisible = true;
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    cards = randomdisco
        .map((gameContents) =>
            GameCardChurch(gameContents: gameContents, fontSize: width * 0.14))
        .toList();
    if (width < 1126 || height < 627) return ReadyChurchPage();
    return Scaffold(
      backgroundColor: const Color.fromRGBO(14, 25, 62, 1),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/background_church.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SafeArea(
            child: Center(
              child: Container(
                padding: EdgeInsets.only(
                  left: width * 0.075,
                  top: height * 0.073,
                  right: width * 0.075,
                ),
                child: RawKeyboardListener(
                  focusNode: focusNode,
                  onKey: (RawKeyEvent event) {
                    if (event is RawKeyDownEvent) {
                      if (event.logicalKey == LogicalKeyboardKey.escape) {
                        Navigator.of(context).pop();
                      } else if (event.logicalKey ==
                          LogicalKeyboardKey.arrowLeft) {
                        controller.undo();
                        if (currentCardIndex == 0) {
                          setState(() {
                            isUndoButtonVisible = true;
                          });
                        }
                      } else if (event.logicalKey ==
                          LogicalKeyboardKey.arrowRight) {
                        if (currentCardIndex == 9) {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const GameOverChurch(
                                gameName: 'churchDisco',
                              ),
                            ),
                          );
                        } else {
                          controller.swipeLeft();
                          if (currentCardIndex != 2) {
                            setState(() {
                              isUndoButtonVisible = false;
                            });
                          }
                        }
                      }
                    }
                  },
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            color: Colors.black,
                            icon: const ImageIcon(
                                AssetImage('assets/images/Exit.png')),
                            iconSize: width * 0.03,
                          ),
                          const Spacer(),
                          Text(
                            '${currentCardIndex + 1}/${cards.length}',
                            style: TextStyle(
                              fontFamily: 'DungGeunMo',
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                              fontSize: width * 0.033,
                            ),
                          ),
                          const Spacer(),
                          SizedBox(width: width * 0.039),
                        ],
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            isUndoButtonVisible
                                ? IconButton(
                                    onPressed: controller.undo,
                                    color: Colors.transparent,
                                    icon: ImageIcon(
                                      const AssetImage(
                                          'assets/images/icon_chevron_left.png'),
                                      color: Colors.black.withOpacity(0.4),
                                    ),
                                    iconSize: width * 0.07,
                                  )
                                : IconButton(
                                    onPressed: () {
                                      controller.undo();
                                      if (currentCardIndex == 0) {
                                        setState(() {
                                          isUndoButtonVisible = true;
                                        });
                                      }
                                    },
                                    color: Colors.transparent,
                                    icon: const ImageIcon(
                                      AssetImage(
                                          'assets/images/icon_chevron_left_white.png'),
                                      color: Colors.black,
                                    ),
                                    iconSize: width * 0.07,
                                  ),
                            SizedBox(
                              width: width * 0.63,
                              height: height * 0.4,
                              child: CardSwiper(
                                duration: const Duration(milliseconds: 0),
                                controller: controller,
                                cardsCount: cards.length,
                                numberOfCardsDisplayed: 1,
                                cardBuilder: (
                                  context,
                                  index,
                                  horizontalThresholdPercentage,
                                  verticalThresholdPercentage,
                                ) {
                                  currentCardIndex = index;
                                  return cards[index];
                                },
                                isDisabled: true,
                                onSwipe: _onSwipe,
                                onUndo: _onUndo,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                if (currentCardIndex == 9) {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const GameOverChurch(
                                        gameName: 'churchDisco',
                                      ),
                                    ),
                                  );
                                } else {
                                  controller.swipeLeft();
                                  if (currentCardIndex != 2) {
                                    setState(() {
                                      isUndoButtonVisible = false;
                                    });
                                  }
                                }
                              },
                              color: Colors.transparent,
                              icon: const ImageIcon(
                                AssetImage(
                                    'assets/images/icon_chevron_right.png'),
                                color: Colors.black,
                              ),
                              iconSize: width * 0.07,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: height * 0.132),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  bool _onSwipe(
    int previousIndex,
    int? currentIndex,
    CardSwiperDirection direction,
  ) {
    setState(() {
      currentCardIndex = currentIndex ?? 0; // currentIndex가 null인 경우 기본값 0으로 설정
    });

    return true;
  }

  bool _onUndo(
    int? previousIndex,
    int currentIndex,
    CardSwiperDirection direction,
  ) {
    setState(() {
      currentCardIndex = currentIndex; // currentIndex가 null인 경우 기본값 0으로 설정
    });
    return true;
  }
}
