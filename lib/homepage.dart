import 'package:flutter/material.dart';
import 'package:flutter_chess_board/flutter_chess_board.dart';
import 'package:project/lichess_requests.dart';

Padding customPaddingText(String text,
    {double allScale = 10, double topScale = -1, double fontSize = 40}) {
  return Padding(
      padding: topScale == -1
          ? EdgeInsets.all(allScale)
          : EdgeInsets.only(top: topScale),
      child: Text(text, style: TextStyle(fontSize: fontSize)));
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  ChessBoardController controller = ChessBoardController();

  late Future<Puzzle> futurePuzzle;
  bool _solutionClicked = false;

  @override
  void initState() {
    super.initState();

    futurePuzzle = LichessRequest().getPuzzle();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        title: const Center(child: Text('Lichess daily puzzle')),
      ),
      body: Center(
        child: FutureBuilder<Puzzle>(
          future: futurePuzzle,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              controller.loadPGN(snapshot.data!.gamePGN);
              return Scaffold(
                  body: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                    Column(
                      children: <Widget>[
                        customPaddingText(
                            'First player: ${snapshot.data!.firstPlayerName}',
                            topScale: 140),
                        customPaddingText(
                            'Second player: ${snapshot.data!.secondPlayerName}'),
                        customPaddingText('Side: ${snapshot.data!.sideTurn()}'),
                        customPaddingText(
                            'Moves to solve: ${snapshot.data!.movesToSolve()}'),
                        customPaddingText(
                            'Puzzle themes:${snapshot.data!.puzzleThemesFlatten()}'),
                        _solutionClicked
                            ? customPaddingText(
                                'Solution:\n${snapshot.data!.solutionPgnFlatten()}')
                            : ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    _solutionClicked = true;
                                  });
                                },
                                child: const Text('View the solution')),
                      ],
                    ),
                    Center(
                        child: ChessBoard(
                      size: 720,
                      controller: controller,
                      boardColor: BoardColor.orange,
                      boardOrientation: snapshot.data!.sideTurn() == "Black"
                          ? PlayerColor.black
                          : PlayerColor.white,
                    ))
                  ]));
            } else if (snapshot.hasError) {
              return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    const Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 60,
                    ),
                    customPaddingText('ERROR: ${snapshot.error}', topScale: 16),
                  ]);
            } else {
              return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const <Widget>[
                    Padding(
                        padding: EdgeInsets.only(top: 30),
                        child: SizedBox(
                          width: 420,
                          height: 420,
                          child: CircularProgressIndicator(),
                        )),
                    Padding(
                        padding: EdgeInsets.only(top: 50),
                        child: Text(
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 30),
                            'Awaiting your puzzle. Be ready!')),
                  ]);
            }
          },
        ),
      ),
    );
  }
}
