class PlayerNotFound implements Exception {
  String msg;
  PlayerNotFound(this.msg);

  @override
  String toString() => "Player $msg not found" ?? 'PlayerNotFound';
}

class Round {}

class Player {
  String name = "";

  Player({this.name});

  String toString() => name;
}

class Tournament {
  List<Player> players = [];

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

  getPlayeryName(String name) {
    for (var player in players) {
      if (player.name == name) {
        return player;
      }
    }
    throw PlayerNotFound(name);
  }
}
