class PlayerNotFound implements Exception {
  String msg;
  PlayerNotFound(this.msg);

  @override
  String toString() => "Player $msg not found" ?? 'PlayerNotFound';
}

class Player implements Comparable {
  String name = "";

  Player({this.name});

  String toString() => name;

  @override
  int compareTo(other) {
    return name.compareTo(other.name);
  }
}

class Match {
  List<Player> players = [];

  Match(this.players);
}

class Round {
  int number = 0;

  List<Match> matches = [];

  void genMatches(List<Player> players) {
    for (var i = 0; i < players.length / 2; i++) {
      int step = i * 2;
      matches.add(Match([players[step], players[step + 1]]));
    }
  }
}

class Tournament {
  List<Player> players = [];
  List<Round> rounds = [];

  int get playerNumbers {
    return players.length;
  }

  void addPlayer(Player player) {
    players.add(player);
  }

  int get roundNumber {
    if (playerNumbers < 9) {
      return 3;
    }
    if (playerNumbers < 17) {
      return 4;
    }
    if (playerNumbers < 33) {
      return 5;
    }
    if (playerNumbers < 65) {
      return 6;
    }
    return 7;
  }

  void start() {
    if (playerNumbers % 2 != 0) {
      addPlayer(Player(name: "BYE"));
    }
  }

  getPlayeryByName(String name) {
    try {
      return players.firstWhere((Player player) => player.name == name);
    } catch (StateError) {
      throw PlayerNotFound(name);
    }
  }

  Round genRound() {
    Round newRound = Round();
    rounds.add(newRound);

    newRound.number = rounds.length;
    newRound.genMatches(players);

    return newRound;
  }
}
