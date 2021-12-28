package io.flutter.plugins;

import io.flutter.plugin.common.PluginRegistry;
import im.zego.zego_express_engine.ZegoExpressEnginePlugin;

/**
 * Generated file. Do not edit.
 */
public final class GeneratedPluginRegistrant {
  public static void registerWith(PluginRegistry registry) {
    if (alreadyRegisteredWith(registry)) {
      return;
    }
    ZegoExpressEnginePlugin.registerWith(registry.registrarFor("im.zego.zego_express_engine.ZegoExpressEnginePlugin"));
  }

  private static boolean alreadyRegisteredWith(PluginRegistry registry) {
    final String key = GeneratedPluginRegistrant.class.getCanonicalName();
    if (registry.hasPlugin(key)) {
      return true;
    }
    registry.registrarFor(key);
    return false;
  }
}
