// lib/presentation/widgets/accessible_form_widgets.dart
import 'package:flutter/material.dart';

import '../theme/pintig_tokens.dart';
import 'pintig_icons.dart';

OutlineInputBorder _border(Color color, double width) => OutlineInputBorder(
      borderRadius: BorderRadius.circular(PintigTokens.inputRadius),
      borderSide: BorderSide(color: color, width: width),
    );

InputDecoration _fieldDecoration({
  String? hint,
  String? unit,
  String? errorText,
  Widget? suffixIcon,
}) {
  return InputDecoration(
    hintText: hint,
    hintStyle: const TextStyle(color: PintigTokens.hintText, fontSize: 17.0),
    errorText: errorText,
    errorStyle: const TextStyle(
      color: PintigTokens.roseInk,
      fontSize: 14.0,
      fontWeight: FontWeight.bold,
    ),
    suffixText: unit,
    suffixStyle: const TextStyle(color: PintigTokens.mutedText, fontSize: 15.0),
    suffixIcon: suffixIcon,
    filled: true,
    fillColor: Colors.white,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
    enabledBorder: _border(PintigTokens.fieldBorder, 1.5),
    focusedBorder: _border(PintigTokens.ink, 2.5),
    errorBorder: _border(PintigTokens.crimson, 2.0),
    focusedErrorBorder: _border(PintigTokens.crimson, 2.5),
    border: _border(PintigTokens.fieldBorder, 1.5),
  );
}

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 15.0,
          fontWeight: FontWeight.bold,
          color: PintigTokens.ink,
        ),
      ),
    );
  }
}

/// Text field with the label above it, an optional unit inside, and an
/// inline error. Same constructor as before plus [unit] and [errorText].
class PintigTextField extends StatelessWidget {
  final String label;
  final String? hint;
  final String? unit;
  final String? errorText;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final bool readOnly;
  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged;
  final Widget? suffixIcon;

  const PintigTextField({
    super.key,
    required this.label,
    this.hint,
    this.unit,
    this.errorText,
    this.controller,
    this.keyboardType,
    this.readOnly = false,
    this.onTap,
    this.onChanged,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _FieldLabel(label),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          readOnly: readOnly,
          onTap: onTap,
          onChanged: onChanged,
          style: const TextStyle(
            fontSize: 19.0,
            fontWeight: FontWeight.bold,
            color: PintigTokens.ink,
          ),
          decoration: _fieldDecoration(
            hint: hint,
            unit: unit,
            errorText: errorText,
            suffixIcon: suffixIcon == null
                ? null
                : Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: suffixIcon,
                  ),
          ),
        ),
      ],
    );
  }
}

/// Dropdown styled to match [PintigTextField].
class PintigDropdownField extends StatelessWidget {
  final String label;
  final String? value;
  final List<String> options;
  final ValueChanged<String> onChanged;

  const PintigDropdownField({
    super.key,
    required this.label,
    required this.value,
    required this.options,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _FieldLabel(label),
        DropdownButtonFormField<String>(
          value: value,
          isExpanded: true,
          icon: const RotatedBox(
            quarterTurns: 1,
            child: PintigIcon(PintigIconName.chevronR, size: 22.0, showDot: false),
          ),
          style: const TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            color: PintigTokens.ink,
            fontFamily: PintigTokens.fontFamily,
          ),
          decoration: _fieldDecoration(),
          items: options
              .map((s) => DropdownMenuItem(value: s, child: Text(s)))
              .toList(),
          onChanged: (val) {
            if (val != null) onChanged(val);
          },
        ),
      ],
    );
  }
}

/// Switch row that turns tinted when ON. Use [tone] to pick the ON colours.
class PintigToggleRow extends StatelessWidget {
  final String title;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  final Color activeColor;
  final Color activeTint;

  const PintigToggleRow({
    super.key,
    required this.title,
    this.subtitle,
    required this.value,
    required this.onChanged,
    this.activeColor = PintigTokens.crimson,
    this.activeTint = PintigTokens.roseTint,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: value ? activeTint : Colors.white,
        borderRadius: BorderRadius.circular(PintigTokens.inputRadius),
        border: Border.all(
          color: value ? activeColor : PintigTokens.fieldBorder,
          width: value ? 2.0 : 1.5,
        ),
      ),
      child: SwitchListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 17.0,
            fontWeight: FontWeight.bold,
            color: PintigTokens.ink,
          ),
        ),
        subtitle: subtitle == null
            ? null
            : Text(
                subtitle!,
                style: const TextStyle(fontSize: 14.0, color: PintigTokens.mutedText),
              ),
        value: value,
        activeColor: Colors.white,
        activeTrackColor: activeColor,
        inactiveThumbColor: Colors.white,
        inactiveTrackColor: PintigTokens.fieldBorder,
        onChanged: onChanged,
      ),
    );
  }
}

class PintigSectionTitle extends StatelessWidget {
  final String text;
  const PintigSectionTitle(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      header: true,
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.bold,
          color: PintigTokens.ink,
        ),
      ),
    );
  }
}

/// Screen header: custom back chevron, title and a line of context.
/// Replaces the old coloured AppBar. Place it at the top of the body.
class PintigScreenHeader extends StatelessWidget {
  final String title;
  final String? subtitle;

  const PintigScreenHeader({super.key, required this.title, this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 8.0, 16.0, 8.0),
      child: Row(
        children: [
          IconButton(
            tooltip: 'Back',
            constraints: const BoxConstraints(minWidth: 52.0, minHeight: 52.0),
            onPressed: () => Navigator.of(context).maybePop(),
            icon: const PintigIcon(PintigIconName.chevronL, size: 28.0, showDot: false),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Semantics(
                  header: true,
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 21.0,
                      fontWeight: FontWeight.bold,
                      color: PintigTokens.ink,
                    ),
                  ),
                ),
                if (subtitle != null)
                  Text(
                    subtitle!,
                    style: const TextStyle(fontSize: 14.0, color: PintigTokens.mutedText),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Pinned bottom panel: live triage result(s) above the Save button, so the
/// result stays visible while the user fills the form. While the keyboard is
/// open only the results are shown.
class PintigActionBar extends StatelessWidget {
  final List<Widget> banners;
  final Widget button;
  final String? disabledHint;

  const PintigActionBar({
    super.key,
    this.banners = const [],
    required this.button,
    this.disabledHint,
  });

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final keyboardOpen = media.viewInsets.bottom > 0;
    if (keyboardOpen && banners.isEmpty) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: PintigTokens.line)),
      ),
      padding: EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 12.0 + media.padding.bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final b in banners) ...[b, const SizedBox(height: 10.0)],
          if (!keyboardOpen) button,
          if (!keyboardOpen && disabledHint != null)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                disabledHint!,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14.0, color: PintigTokens.mutedText),
              ),
            ),
        ],
      ),
    );
  }
}

/// Main action button. Disabled when [onPressed] is null.
class PintigPrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;

  const PintigPrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56.0,
      child: FilledButton(
        onPressed: isLoading ? null : onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: PintigTokens.crimson,
          foregroundColor: Colors.white,
          disabledBackgroundColor: const Color(0xFFD5DCE1),
          disabledForegroundColor: PintigTokens.mutedText,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.0)),
          textStyle: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
        ),
        child: isLoading
            ? const SizedBox(
                width: 24.0,
                height: 24.0,
                child: CircularProgressIndicator(strokeWidth: 3.0, color: Colors.white),
              )
            : Text(label),
      ),
    );
  }
}

enum PintigTone { critical, caution, ok }

/// Triage result. Tinted background with dark text (not white on a solid
/// colour), icon plus words so colour is never the only signal, and announced
/// to screen readers when it changes.
class PintigCdssBanner extends StatelessWidget {
  final String title;
  final String message;
  final PintigTone tone;
  final PintigIconName icon;

  const PintigCdssBanner({
    super.key,
    required this.title,
    required this.message,
    this.tone = PintigTone.caution,
    this.icon = PintigIconName.alert,
  });

  @override
  Widget build(BuildContext context) {
    final Color tint;
    final Color ink;
    final Color accent;
    switch (tone) {
      case PintigTone.critical:
        tint = PintigTokens.roseTint;
        ink = PintigTokens.roseInk;
        accent = PintigTokens.crimson;
        break;
      case PintigTone.caution:
        tint = PintigTokens.amberTint;
        ink = PintigTokens.amberInk;
        accent = PintigTokens.amber;
        break;
      case PintigTone.ok:
        tint = PintigTokens.seaTint;
        ink = PintigTokens.seaInk;
        accent = PintigTokens.sea;
        break;
    }

    return Semantics(
      liveRegion: true,
      container: true,
      label: '$title. $message',
      child: ExcludeSemantics(
        child: Container(
          padding: const EdgeInsets.all(14.0),
          decoration: BoxDecoration(
            color: tint,
            borderRadius: BorderRadius.circular(14.0),
            border: Border.all(color: accent.withOpacity(0.35), width: 1.0),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PintigIcon(icon, size: 28.0, color: accent, dotColor: accent),
              const SizedBox(width: 12.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold, color: ink),
                    ),
                    const SizedBox(height: 2.0),
                    Text(
                      message,
                      style: TextStyle(fontSize: 14.5, height: 1.35, color: ink),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
