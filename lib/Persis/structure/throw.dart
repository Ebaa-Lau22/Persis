class Throw {
  final String name;
  final double rate;
  final int steps;
  final int upShells;
  final bool khal;
  final bool throwAgain;
  final String stepsText;

  Throw({required this.name, required this.rate, required this.upShells, required this.steps, required this.stepsText, required this.khal,
    required this.throwAgain});

  static Throw getThrow(int upShells) {
    switch(upShells){
      case 0:
        return Throw(
            name: 'بارا',
            rate: 0.028,
            khal: false,
            upShells: 0,
            steps: 12,
            stepsText: '12 نقلة',
            throwAgain: true
        );
      case 1:
        return Throw(
            name: 'بنج',
            rate: 0.136,
            khal: true,
            upShells: 1,
            steps: 25,
            stepsText: '24 نقلة + خال',
            throwAgain: true);
      case 2:
        return Throw(
            name: 'أربعة',
            rate: 0.278,
            khal: false,
            upShells: 2,
            steps: 4,
            stepsText: '4 نقلات',
            throwAgain: false);
      case 3:
        return Throw(
            name: 'ثلاثة',
            rate: 0.303,
            khal: false,
            upShells: 3,
            steps: 3,
            stepsText: '3 نقلات',
            throwAgain: false);
      case 4:
        return Throw(
            name: 'دواق',
            rate: 0.186,
            khal: false,
            upShells: 4,
            steps: 2,
            stepsText: 'نقلتان',
            throwAgain: false);
      case 5:
        return Throw(
            name: 'دست',
            rate: 0.061,
            khal: true,
            upShells: 5,
            steps: 10,
            stepsText: '10 نقلات + خال',
            throwAgain: true);
       default:
        return Throw(
            name: 'شكة',
            rate: 0.008,
            khal: false,
            upShells: 6,
            steps: 6,
            stepsText: '6 نقلات',
            throwAgain: true);
    }
  }

}
