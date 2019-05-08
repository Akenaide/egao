const WIN_POWER = 10;

class PlayerNotFound implements Exception {
  String msg;
  PlayerNotFound(this.msg);

  @override
  String toString() => "Player $msg not found" ?? 'PlayerNotFound';
}

class PairingError implements Exception {
  String msg;
  PairingError(this.msg);

  @override
  String toString() => "Pairing error with $msg" ?? 'PairingError';
}

class Player implements Comparable {
  String name = "";
  int power = 0;
  bool available = true;
  List<Player> opponents = [];

  Player({this.name});

  String toString() => name;

  @override
  int compareTo(other) {
    return name.compareTo(other.name);
  }

  bool goodOppo(Player player) {
    bool alreadyFought = opponents.contains(player);
    return player.available && player.power == power && !alreadyFought;
  }
}

class Match {
  List<Player> players = [];
  Player winner;
  Match(this.players);

  void setWinner(Player player) {
    winner = player;
    player.power = player.power + WIN_POWER;
  }
}

class Round {
  int number = 0;
  List<Match> matches = [];

  void genMatches(List<Player> players) {
    players.forEach((Player player) => player.available = true);
    bool continueGen = true;

    // Is it good performance wise ?
    while (continueGen) {
      players.shuffle();
      try {
        matches.addAll(_genMatches(players));
      } catch (PairingError) {
        print(PairingError.toString());
      }
      continueGen = false;
    }
  }

  List<Match> _genMatches(List<Player> players) {
    Player p1, p2;
    List<Match> _matches = [];

    try {
      for (var i = 0; i < players.length / 2; i++) {
        p1 = players.firstWhere((Player player) {
          return player.available;
        });
        p1.available = false;

        p2 = players.firstWhere((Player player) {
          return p1.goodOppo(player);
        });
        p2.available = false;
        p1.opponents.add(p2);
        p2.opponents.add(p1);

        _matches.add(Match([p1, p2]));
      }
    } catch (StateError) {
      throw PairingError("$p1");
    }
    return _matches;
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
