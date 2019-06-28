@TestOn('vm')
import 'package:test/test.dart';

import 'package:egao/models.dart';

List<Player> addXplayer(int nb, Tournament tourna) {
  List<Player> players = [];
  for (var i = 0; i < nb; i++) {
    var player = Player(name: "$i");
    tourna.addPlayer(player);
    players.add(player);
  }
  return players;
}

void main() {
  group("Round", () {
    test('Round number', () {
      var _tourna = Tournament();
      addXplayer(7, _tourna);
      expect(3, equals(_tourna.roundNumber));
      addXplayer(99, _tourna);
      expect(7, equals(_tourna.roundNumber));
    });

    test("Good round number", () {
      var _tourna = Tournament();
      addXplayer(8, _tourna);

      Round round1 = _tourna.genRound();
      expect(round1.number, equals(1));

      Round round2 = _tourna.genRound();
      expect(round2.number, equals(2));
    });

    // TODO: test player 1 is in only one match
    test("Everyone is in a match", () {
      var _tourna = Tournament();
      var _players = addXplayer(8, _tourna);

      Round round1 = _tourna.genRound();
      expect(round1.matches.length, equals(4));

      for (var player in _players) {
        bool found = false;
        for (var match in round1.matches) {
          if (match.players.contains(player)) {
            found = true;
            break;
          }
        }
        if (!found) {
          fail("Player: $player not found");
        }
      }
    });
  });

  group("Tournament", () {
    test("Add player", () {
      var _tourna = Tournament();
      _tourna.addPlayer(Player());
      expect(1, equals(_tourna.playerNumbers));
    });

    test("Has Bye", () {
      var _tourna = Tournament();
      addXplayer(7, _tourna);
      _tourna.start();
      expect(_tourna.getPlayeryByName("BYE"), TypeMatcher<Player>());
    });

    test("Hasn't Bye", () {
      var _tourna = Tournament();
      addXplayer(8, _tourna);
      _tourna.start();

      void exceptionExpected() => _tourna.getPlayeryByName("BYE");

      expect(exceptionExpected, throwsA(TypeMatcher<PlayerNotFound>()));
    });

    test("Standing", () {
      var _tourna = Tournament();
      var expected = List<Player>();
      Player p1 = Player.score(name: "p1", win: 4, loose: 0);
      Player p2 = Player.score(name: "p2", win: 3, loose: 1);
      Player p3 = Player.score(name: "p3", win: 0, loose: 4);

      expected.add(p1);
      expected.add(p2);
      expected.add(p3);

      _tourna.addPlayer(p1);
      _tourna.addPlayer(p2);
      _tourna.addPlayer(p3);

      expect(expected, equals(_tourna.standing));
    });

    test("Righ oppo advance", () {
      var _tourna = Tournament();
      var expected = List<Player>();
      addXplayer(7, _tourna);
      _tourna.start();

      for (var i = 0; i < _tourna.roundNumber; i++) {
        Round _round = _tourna.genRound();
        for (var match in _round.matches) {
          match.setWinner(match.players[0]);
        }
      }

      // _tourna.standing[0].score = "3-0";
      expect(_tourna.standing[0].score, equals("3-0"));
      expect(_tourna.standing[1].score, equals("2-1"));
      expect(_tourna.standing[2].score, equals("2-1"));
      expect(_tourna.standing[3].score, isIn(["2-1", "1-2"]));
      expect(_tourna.standing[4].score, isIn(["2-1", "1-2"]));
      expect(_tourna.standing[5].score, equals("1-2"),
          reason: _tourna.standing[5].opponents.toString());
      expect(_tourna.standing[6].score, equals("1-2"));

      fail("message");
    });
  });
  group("Paring", () {
    test("simple tournament power of 2", () {
      var _tourna = Tournament();
      addXplayer(64, _tourna);
      _tourna.start();
      for (var i = 0; i < _tourna.roundNumber; i++) {
        Round _round = _tourna.genRound();
        for (var match in _round.matches) {
          expect(match.players[0].power, equals(match.players[1].power));
        }
        for (var match in _round.matches) {
          match.setWinner(match.players[0]);
        }
      }
    });

    test("Avoid same opponent power of 2", () {
      var _tourna = Tournament();
      addXplayer(128, _tourna);
      _tourna.start();
      for (var i = 0; i < _tourna.roundNumber; i++) {
        Round _round = _tourna.genRound();
        for (var match in _round.matches) {
          match.setWinner(match.players[0]);
        }
      }
      for (var player in _tourna.players) {
        for (var opponent in player.opponents) {
          int occurence = player.opponents.where((Player _oppo) {
            return _oppo == opponent;
          }).length;
          expect(1, occurence,
              reason:
                  "Player $player was paired more than one againts $opponent (${player.opponents})");
        }
      }
    });

    test("Avoid same opponent", () {
      var _tourna = Tournament();
      addXplayer(7, _tourna);
      _tourna.start();
      for (var i = 0; i < _tourna.roundNumber; i++) {
        Round _round = _tourna.genRound();
        for (var match in _round.matches) {
          match.setWinner(match.players[0]);
        }
      }
      for (var player in _tourna.players) {
        for (var opponent in player.opponents) {
          int occurence = player.opponents.where((Player _oppo) {
            return _oppo == opponent;
          }).length;
          expect(1, occurence,
              reason:
                  "Player $player was paired more than one againts $opponent (${player.opponents})");
        }
      }
    });
  });
}
