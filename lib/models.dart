const WIN_POWER = 10;

class PlayerNotFound implements Exception {
  String msg;
  PlayerNotFound(this.msg);

  @override
  String toString() => "Player $msg not found" ?? 'PlayerNotFound';
}

class Player implements Comparable {
  String name = "";

  int power = 0;

  bool available = true;

  Player({this.name});

  String toString() => name;

  @override
  int compareTo(other) {
    return name.compareTo(other.name);
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

    for (var i = 0; i < players.length / 2; i++) {
      Player p1, p2;
      p1 = players.firstWhere((Player player) {
        return player.available;
      });
      p1.available = false;

      p2 = players.firstWhere((Player player) {
        return player.available && player.power == p1.power;
      });
      p2.available = false;
      matches.add(Match([p1, p2]));
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
