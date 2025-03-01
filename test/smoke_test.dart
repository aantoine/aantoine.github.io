// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:card/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('smoke test', (tester) async {
    // Build our game and trigger a frame.
    await tester.pumpWidget(MyApp());
  });
}
