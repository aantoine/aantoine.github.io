// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/material.dart';

/// A palette of colors to be used in the game.
///
/// The reason we're not going with something like Material Design's
/// `Theme` is simply that this is simpler to work with and yet gives
/// us everything we need for a game.
///
/// Games generally have more radical color palettes than apps. For example,
/// every level of a game can have radically different colors.
/// At the same time, games rarely support dark mode.
///
/// Colors taken from this fun palette:
/// https://lospec.com/palette-list/crayola84
///
/// Colors here are implemented as getters so that hot reloading works.
/// In practice, we could just as easily implement the colors
/// as `static const`. But this way the palette is more malleable:
/// we could allow players to customize colors, for example,
/// or even get the colors from the network.
class Palette {
  Color get pen => const Color(0xff1d75fb);
  Color get darkPen => const Color(0xFF0050bc);
  Color get redPen => const Color(0xFFd10841);
  Color get inkFullOpacity => const Color(0xffffffff);
  Color get ink => const Color(0xffffffff);
  Color get accept => const Color(0xff15a44d);
  Color get backgroundMain => const Color(0xff074752);
  Color get backgroundLevelSelection => const Color(0xffa2dcc7);
  Color get backgroundPlaySession => const Color(0xffffebb5);
  Color get background4 => const Color(0xffffffd1);
  Color get backgroundSettings => const Color(0xff7dc142);
  Color get trueWhite => const Color(0xffffffff);

  // -----------

  // https://material-foundation.github.io/material-theme-builder/
  // primary: #074752
  // secondary: #7DC142
  // Dark variant
  Color get surface => const Color(0xff0e1416);
  Color get surfaceContainer => const Color(0xff1b2122);
  Color get surfaceContainerHigh => const Color(0xff252b2d);
  Color get surfaceContainerHighest => const Color(0xff303637);
  Color get onSurface => const Color(0xffdee3e5);
  Color get onSurfaceVariant => const Color(0xffbfc8cb);
  Color get surfaceOutline => const Color(0xff899295);

  Color get primary => const Color(0xff83d2e5);
  Color get secondary => const Color(0xffaed18d);
  Color get onPrimary => const Color(0xff00363f);
  Color get onSecondary => const Color(0xff1c3703);

  Color get primaryContainer => const Color(0xff004e5b);
  Color get secondaryContainer => const Color(0xff324e19);
  Color get onPrimaryContainer => const Color(0xffa6eeff);
  Color get onSecondaryContainer => const Color(0xffc9eea7);

  Color get error => const Color(0xffffb4ab);
  Color get onError => const Color(0xff690005);
  Color get errorContainer => const Color(0xff93000a);
  Color get onErrorContainer => const Color(0xffffdad6);
}
