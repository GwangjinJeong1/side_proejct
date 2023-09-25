import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:testes/image_card.dart';
import '../game_contents.dart';
import '../card_app.dart';
import '../gameover/gameover_app.dart';

class RandomAppGame extends StatefulWidget {
  final String id;

  const RandomAppGame({
    super.key,
    required this.id,
  });

  @override
  State<RandomAppGame> createState() => _RandomAppGameState();
}

class _RandomAppGameState extends State<RandomAppGame> {
  int currentCardIndex = 0; // 현재 카드의 인덱스를 저장할 변수
  final CardSwiperController controller = CardSwiperController();
  List<GameCardApp> cards = []; // cards 변수를 초기화
  List<ImageGameCard> imagecards = []; // cards 변수를 초기화
  String setNumber = '';
  @override
  void initState() {
    super.initState();

    // widget.id 값에 따라 cards 변수에 값을 할당
    if (widget.id == 'SET 1') {
      cards = random1
          .map((gameContents) => GameCardApp(gameContents: gameContents))
          .toList();
    } else if (widget.id == 'SET 2') {
      imagecards = random2
          .map((gameContents) => ImageGameCard(gameContents: gameContents))
          .toList();
    } else if (widget.id == 'SET 3') {
      cards = random3
          .map((gameContents) => GameCardApp(gameContents: gameContents))
          .toList();
    } else if (widget.id == 'SET 4') {
      cards = random4
          .map((gameContents) => GameCardApp(gameContents: gameContents))
          .toList();
    } else {
      cards = random5
          .map((gameContents) => GameCardApp(gameContents: gameContents))
          .toList();
    }
    setNumber = widget.id;
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
    return Scaffold(
      backgroundColor: const Color.fromRGBO(14, 25, 62, 1),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.only(
            left: width * 0.075,
            top: height * 0.073,
            right: width * 0.0797,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    color: Colors.white,
                    icon: const ImageIcon(AssetImage('assets/images/Exit.png')),
                    iconSize: 27,
                  ),
                ],
              ),
              Text(
                setNumber,
                style: const TextStyle(
                  fontFamily: 'DungGeunMo',
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                  fontSize: 34,
                ),
              ),
              SizedBox(height: height * 0.025),
              if (widget.id == 'SET 2')
                Text(
                  '${currentCardIndex + 1} / ${imagecards.length}',
                  style: const TextStyle(
                    fontFamily: 'DungGeunMo',
                    color: Color.fromRGBO(255, 98, 211, 1),
                    fontWeight: FontWeight.w400,
                    fontSize: 26,
                  ),
                )
              else
                Text(
                  '${currentCardIndex + 1} / ${cards.length}',
                  style: const TextStyle(
                    fontFamily: 'DungGeunMo',
                    color: Color.fromRGBO(255, 98, 211, 1),
                    fontWeight: FontWeight.w400,
                    fontSize: 26,
                  ),
                ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    isUndoButtonVisible
                        ? ConstrainedBox(
                            constraints: const BoxConstraints.tightFor(
                                width: 29, height: 52),
                            child: ElevatedButton(
                              onPressed: () {
                                controller.undo;
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                padding: const EdgeInsets.only(left: 0),
                              ),
                              child: const ImageIcon(
                                AssetImage(
                                    'assets/images/icon_chevron_left.png'),
                                size: 90,
                              ),
                            ),
                          )
                        : ConstrainedBox(
                            constraints: const BoxConstraints.tightFor(
                                width: 29, height: 52),
                            child: ElevatedButton(
                              onPressed: () {
                                controller.undo();
                                if (currentCardIndex == 0) {
                                  setState(() {
                                    isUndoButtonVisible = true;
                                  });
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                padding: const EdgeInsets.only(left: 0),
                              ),
                              child: const ImageIcon(
                                AssetImage(
                                    'assets/images/icon_chevron_left_white.png'),
                                size: 90,
                              ),
                            ),
                          ),
                    if (widget.id == 'SET 2')
                      SizedBox(
                        width: width * 0.57, // 최대 가로 크기를 설정할 수도 있습니다.
                        height: height * 0.67, // 최대 세로 크기를 설정할 수도 있습니다
                        child: CardSwiper(
                          duration: const Duration(milliseconds: 0),
                          controller: controller,
                          cardsCount: imagecards.length,
                          numberOfCardsDisplayed: 1,
                          cardBuilder: (
                            context,
                            index,
                            horizontalThresholdPercentage,
                            verticalThresholdPercentage,
                          ) {
                            currentCardIndex = index;
                            return imagecards[index];
                          },
                          isDisabled: true,
                          onSwipe: _onSwipe,
                          onUndo: _onUndo,
                        ),
                      )
                    else
                      SizedBox(
                        width: width * 0.69,
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
                              builder: (context) => GameOverApp(
                                id: widget.id,
                                gameName: 'random',
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
                        AssetImage('assets/images/icon_chevron_right.png'),
                      ),
                      iconSize: 90,
                    ),
                  ],
                ),
              ),
              if (widget.id != 'SET 2') const SizedBox(height: 87)
            ],
          ),
        ),
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
