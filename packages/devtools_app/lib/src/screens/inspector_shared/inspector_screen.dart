// Copyright 2024 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:devtools_app_shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../shared/feature_flags.dart';
import '../../shared/globals.dart';
import '../../shared/screen.dart';
import '../inspector/inspector_screen_body.dart' as legacy;
import '../inspector_v2/inspector_screen_body.dart' as v2;
import 'inspector_screen_controller.dart';

class InspectorScreen extends Screen {
  InspectorScreen() : super.fromMetaData(ScreenMetaData.inspector);

  static const minScreenWidthForTextBeforeScaling = 900.0;

  static final id = ScreenMetaData.inspector.id;

  // There is not enough room to safely show the console in the embed view of
  // the DevTools and IDEs have their own consoles.
  @override
  bool showConsole(EmbedMode embedMode) => !embedMode.embedded;

  @override
  String get docPageId => screenId;

  @override
  Widget buildScreenBody(BuildContext context) =>
      const InspectorScreenSwitcher();
}

class InspectorScreenSwitcher extends StatelessWidget {
  const InspectorScreenSwitcher({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<InspectorScreenController>(context);

    return ValueListenableBuilder(
      valueListenable: preferences.inspector.inspectorV2Enabled,
      builder: (context, v2Enabled, _) {
        if (FeatureFlags.inspectorV2 && v2Enabled) {
          return v2.InspectorScreenBody(
            controller: controller.v2InspectorController,
          );
        }

        return legacy.InspectorScreenBody(
          controller: controller.legacyInspectorController,
        );
      },
    );
  }
}
