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
  });
  group("Paring", () {
    test("round 2 win VS win", () {
      var _tourna = Tournament();
      addXplayer(8, _tourna);
      _tourna.start();
      _tourna.genRound();

      fail("e");
    });
  });
}
