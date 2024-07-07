import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'widgets/button.dart';
import 'widgets/splash_effect.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  double _buttonRadius = 25;
  bool splash = false;
  bool splashOnAc = true;
  bool vibrateOnTap = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Settings'),
          centerTitle: true,
        ),
        body: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 18),
          children: [
            NeumorphicButton(
              borderRadius: BorderRadius.circular(_buttonRadius),
              child: const ListTile(
                title: Text('Theme'),
                trailing: Icon(Icons.arrow_forward_ios),
              ),
              onPressed: () {
                // Navigator.pushNamed(context, '/theme');
              },
            ),
            const SizedBox(height: 18.0),
            NeumorphicButton(
              borderRadius: BorderRadius.circular(_buttonRadius),
              child: ListTile(
                title: const Text('Font'),
                trailing: Text(
                    Theme.of(context).textTheme.bodyLarge?.fontFamily ?? ''),
              ),
              onPressed: () {
                // Navigator.pushNamed(context, '/theme');
              },
            ),
            const SizedBox(height: 18.0),
            NeumorphicButton(
              borderRadius: BorderRadius.circular(_buttonRadius),
              height: kToolbarHeight,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Button Border Radius'),
                    Slider(
                        divisions: 20,
                        label: _buttonRadius.toString(),
                        value: _buttonRadius,
                        onChanged: (val) {
                          setState(() => _buttonRadius = val);
                        },
                        max: 25,
                        min: 5)
                  ],
                ),
              ),
              onPressed: () {
                // Navigator.pushNamed(context, '/theme');
              },
            ),
            const SizedBox(height: 18.0),
            NeumorphicButton(
              borderRadius: BorderRadius.circular(_buttonRadius),
              child: SwitchListTile(
                value: vibrateOnTap,
                onChanged: (val) {
                  if (val) {
                    HapticFeedback.mediumImpact();
                  }
                  setState(() => vibrateOnTap = val);
                },
                title: const Text('Vibrate on Tap'),
              ),
              onPressed: () {
                // Navigator.pushNamed(context, '/theme');
              },
            ),
            const SizedBox(height: 18.0),
            SplashEffect(
              splash: splash,
              child: NeumorphicButton(
                borderRadius: BorderRadius.circular(_buttonRadius),
                onPressed: null,
                onLongPress: () => setState(() => splash = !splash),
                child: SwitchListTile(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(_buttonRadius)),
                  value: splashOnAc,
                  onChanged: (val) => setState(() => splashOnAc = val),
                  title: const Text('Splash Effect on AC'),
                  subtitle: const Text('Long tap here for demo'),
                ),
              ),
            ),
          ],
        ));
  }
}
