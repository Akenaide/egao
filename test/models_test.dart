@TestOn('vm')
import 'package:test/test.dart';
// import 'package:mockito/mockito.dart';

// import 'package:egao/service.dart';
import 'package:egao/models.dart';

void addXplayer(int nb, Tournament tourna) {
  for (var i = 0; i < nb; i++) {
    tourna.addPlayer(Player(name: ""));
  }
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
      expect(_tourna.getPlayeryName("BYE"), isA<Player>());
    });

    test("Hasn't Bye", () {
      var _tourna = Tournament();
      addXplayer(8, _tourna);
      _tourna.start();

      void exceptionExpected() => _tourna.getPlayeryName("BYE");

      expect(exceptionExpected, throwsA(isA<PlayerNotFound>()));
    });
  });
}
