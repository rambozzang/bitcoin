import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Utils {
  static Color get bgcolor => Color.fromARGB(255, 22, 39, 84);
  static Color get upbgcolor => Color(0xFFD24F45);
  static Color get upbgcolor2 => Color(0xFFEAADA9);

  // static Color get upcolor => Color.fromARGB(255, 37, 57, 81);

  static Color get downbgcolor => Color(0xFF1164C4);
  static Color get downbgcolor2 => Color(0xFF99BEE9);
  // static Color get downcolor => Color.fromARGB(255, B9, 4E, 46);

  static getMoneyformat(dynamic price) {
    if (price == null) {
      return '0';
    }

    if (price == '') {
      return '0';
    }
    if (price.toString() == '0') {
      return '0';
    }

    if (price.runtimeType != double) {
      price = double.parse(price.toString());
    }

    if (price > 999) {
      return NumberFormat('###,###,###,###')
          .format(price ?? '0')
          .replaceAll(' ', '');
    } else if (price >= 100 && price <= 999) {
      return NumberFormat('###.#').format(price ?? '0').replaceAll(' ', '');
    } else if (price >= 10 && price <= 99.999999) {
      return NumberFormat('##.00#').format(price ?? '0').replaceAll(' ', '');
    } else if (price >= 1 && price <= 9.9999999) {
      return NumberFormat('#.####').format(price ?? '0').replaceAll(' ', '');
    } else if (price > 0.01 && price < 1) {
      return NumberFormat('#.####').format(price ?? '0').replaceAll(' ', '');
    } else if (price > 0.0001 && price <= 0.01) {
      return NumberFormat('0.#####').format(price ?? '0').replaceAll(' ', '');
    } else if (price <= 0.0001) {
      return NumberFormat('0.###########')
          .format(price ?? '0')
          .replaceAll(' ', '');
    }
  }

  static Color getTickerColor(double price) {
    return price > 0.0
        ? upbgcolor
        : price == 0.0
            ? Colors.black
            : downbgcolor;
  }

  static TextStyle getTextStyle(double price, double sz) {
    return price > 0.0
        ? TextStyle(
            color: upbgcolor, fontSize: sz, fontWeight: FontWeight.normal)
        : price == 0.0
            ? TextStyle(
                color: Colors.black,
                fontSize: sz,
                fontWeight: FontWeight.normal)
            : TextStyle(
                color: downbgcolor,
                fontSize: sz,
                fontWeight: FontWeight.normal);
  }
}
