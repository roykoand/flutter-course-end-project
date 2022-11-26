import "package:requests/requests.dart";
import "dart:convert";

class Puzzle {
  final String puzzleId;
  final String firstPlayerName;
  final String secondPlayerName;
  final String gamePGN;
  final List<dynamic> solutionPGN;
  final List<dynamic> gameThemes;

  const Puzzle(
      {required this.puzzleId,
      required this.firstPlayerName,
      required this.secondPlayerName,
      required this.gamePGN,
      required this.solutionPGN,
      required this.gameThemes});

  factory Puzzle.fromJson(Map<String, dynamic> json) {
    return Puzzle(
        puzzleId: json["puzzle"]!["id"],
        firstPlayerName: json["game"]!["players"][0]["name"] ?? "",
        secondPlayerName: json["game"]!["players"][1]["name"] ?? "",
        gamePGN: json["game"]!["pgn"] ?? "",
        solutionPGN: json["puzzle"]!["solution"] ?? [],
        gameThemes: json["puzzle"]!["themes"] ?? []);
  }

  int movesToSolve() {
    return (solutionPGN.length / 2).ceil();
  }

  String sideTurn() {
    String pgnSeparator = " ";
    // "W B => [W, B]"
    if (gamePGN.isNotEmpty && gamePGN.split(pgnSeparator).length % 2 == 0) {
      return "White";
    } else {
      return "Black";
    }
  }

  String puzzleThemesFlatten() {
    String bulletSeparator = "\n\u2022 ";
    return bulletSeparator + gameThemes.join(bulletSeparator);
  }

  String solutionPgnFlatten() {
    return solutionPGN.join(" ");
  }
}

class LichessRequest {
  String apiURL = "https://lichess.org/api/puzzle/";

  Future<Puzzle> getPuzzle({puzzleId = "daily"}) async {
    var response = await Requests.get("$apiURL$puzzleId");

    if (response.statusCode == 200) {
      return Puzzle.fromJson(json.decode(response.body));
    } else {
      throw Exception("Ooops! API request is unsuccessful");
    }
  }
}
