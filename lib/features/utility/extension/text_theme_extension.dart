import 'package:flutter/material.dart';

import '../const/constant_color.dart';

/// TextTheme için kolay kullanım extension'ı
/// Uygulama genelinde tutarlı text stilleri için
extension AppTextTheme on BuildContext {
  TextTheme get textTheme => Theme.of(this).textTheme;

  // Başlıklar
  TextStyle get pageTitle =>
      textTheme.headlineLarge!.copyWith(color: Theme.of(this).primaryColor);

  TextStyle get priceTitle => textTheme.headlineMedium!.copyWith(
    color: Theme.of(this).primaryColor,
    fontSize: 23,
  );

  TextStyle get subTitle =>
      textTheme.titleMedium!.copyWith(fontSize: 24, fontWeight: FontWeight.bold);

  TextStyle get sectionTitle =>
      textTheme.titleLarge!.copyWith(color: Theme.of(this).primaryColor);

  TextStyle get cardTitle =>
      textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w600);

  // Body metinler
  TextStyle get bodyPrimary => textTheme.bodyLarge!;

  TextStyle get bodySecondary =>
      textTheme.bodyMedium!.copyWith(color: ConstColor.grey600);

  // Butonlar
  TextStyle get buttonText =>
      textTheme.labelLarge!.copyWith(fontWeight: FontWeight.w600);
      
  TextStyle get buttonTextWhite =>
      textTheme.labelLarge!.copyWith(fontWeight: FontWeight.w600, color: ConstColor.white);

  // Küçük metinler
  TextStyle get caption =>
      textTheme.bodySmall!.copyWith(color: ConstColor.grey500);

  // Özel renkli metinler
  TextStyle get primaryText =>
      textTheme.bodyLarge!.copyWith(color: Theme.of(this).primaryColor);

  TextStyle get errorText => textTheme.bodyMedium!.copyWith(color: ConstColor.red);

  TextStyle get successText =>
      textTheme.bodyLarge!.copyWith(color: ConstColor.green, fontSize: 20);

  TextStyle get paymentErrorText =>
      textTheme.bodyLarge!.copyWith(color: ConstColor.red, fontSize: 24);

  TextStyle get hospitalNameText => textTheme.bodyLarge!.copyWith(
    color: ConstColor.white,
    fontSize: 28,
    fontWeight: FontWeight.bold,
    letterSpacing: 0.5,
  );
  
  TextStyle get tcLoginText =>
      textTheme.bodyMedium!.copyWith(color: ConstColor.black, fontSize: 38);
      
  TextStyle get birthDayLoginText =>
      textTheme.bodyMedium!.copyWith(color: ConstColor.black, fontSize: 28);
      
  TextStyle get otpLoginText =>
      textTheme.bodyMedium!.copyWith(color: ConstColor.black, fontSize: 28);
      
  TextStyle get languageFlag => textTheme.bodyMedium!.copyWith(fontSize: 35);
  
  TextStyle get languageText => textTheme.bodyMedium!.copyWith(fontSize: 18);
  
  TextStyle get keypadButtonText => textTheme.bodyMedium!.copyWith(fontSize: 30, fontWeight: FontWeight.w300, color: ConstColor.black);
  
  TextStyle get questionnaireText =>
      textTheme.bodyMedium!.copyWith(color: ConstColor.black, fontSize: 25);
      
  TextStyle get clearText =>
      textTheme.bodyMedium!.copyWith(fontSize: 18, color: ConstColor.red);
      
  // Input field styles
  TextStyle get inputFieldText =>
      textTheme.bodyMedium!.copyWith(fontSize: 25, color: ConstColor.black);
      
  TextStyle get inputFieldReadOnly =>
      textTheme.bodyMedium!.copyWith(fontSize: 25, color: ConstColor.grey600);
      
  TextStyle get inputLabelText =>
      textTheme.bodyMedium!.copyWith(fontSize: 16, fontWeight: FontWeight.bold);
      
  TextStyle get inputHintText =>
      textTheme.bodyMedium!.copyWith(color: ConstColor.grey500, fontSize: 16);
      
  TextStyle get inputCounterText =>
      textTheme.bodySmall!.copyWith(fontSize: 12, fontWeight: FontWeight.w500);
      
  TextStyle get inputErrorText =>
      textTheme.bodySmall!.copyWith(color: ConstColor.red, fontSize: 14, fontWeight: FontWeight.w500);
  
  // Dialog styles
  TextStyle get dialogTitle =>
      textTheme.titleLarge!.copyWith(color: ConstColor.black);
      
  TextStyle get dialogContent =>
      textTheme.bodyMedium!.copyWith(color: ConstColor.black);
      
  TextStyle get dialogContentSecondary =>
      textTheme.bodyMedium!.copyWith(color: ConstColor.grey600);
  
  // Button specific styles
  TextStyle get saveButtonText =>
      textTheme.labelLarge!.copyWith(fontSize: 18, color: ConstColor.white);
      
  TextStyle get whiteButtonText =>
      textTheme.labelLarge!.copyWith(color: ConstColor.white);
  
  // Misc
  TextStyle get notFoundText =>
      textTheme.bodyMedium!.copyWith(fontSize: 18, color: ConstColor.grey600);
      
  TextStyle get regularText18 =>
      textTheme.bodyMedium!.copyWith(fontSize: 18);
      
  TextStyle get warningTitle =>
      textTheme.bodyMedium!.copyWith(fontSize: 23, fontWeight: FontWeight.bold);
      
  TextStyle get warningText =>
      textTheme.bodyMedium!.copyWith(fontSize: 18, color: ConstColor.red);
}

