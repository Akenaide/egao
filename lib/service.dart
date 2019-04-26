int getRoundNumber(int players) {
  if (players < 9) {
    return 3;
  }
  if (players < 17) {
    return 4;
  }
  if (players < 33) {
    return 5;
  }
  if (players < 65) {
    return 6;
  }
  return 7;
}
