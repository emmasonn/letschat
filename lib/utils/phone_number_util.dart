///process users phonenumber to follow NG format
///eg: 08034244344 will be +2348034244344
///eg2: +23408031344386 will be +2348031344386
String processNumber(String number) {
  final numReversed = number.split('').reversed.join();
  final mainDigits = numReversed.substring(0, 10);
  final reverseBack = mainDigits.split('').reversed.join();
  return '+234$reverseBack';
}
