enum CalculatorButton {
  allClear('AC'),
  negative('+/-'),
  percent('%'),
  divide('÷'),
  //
  seven('7'),
  eight('8'),
  nine('9'),
  multiply('x'),
  //
  four('4'),
  five('5'),
  six('6'),
  subtract('-'),
  //
  one('1'),
  two('2'),
  three('3'),
  add('+'),
  //
  zero('0'),
  decimal('.'),
  clear('C'),
  equal('=');

  final String value;
  const CalculatorButton(this.value);

  bool get isNumber => int.tryParse(value) != null;
}
