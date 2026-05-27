import 'package:flutter/material.dart';

/// Cores da aplicação
class AppColors {
  // Cores primárias
  static const Color primaryColor = Color.fromARGB(255, 236, 163, 29);

  // Variação mais clara da cor primária
  static const Color primariaClara = Color.fromARGB(134, 237, 202, 138);

  // Fundo principal das telas
  static const Color backgroundColor = Color.fromARGB(255, 244, 220, 180);

  // Fundo de cards
  static const Color fundoCard = Color.fromARGB(202, 243, 242, 242);

  // Fundo da bottom bar
  static const Color fundoBottomBar = Color.fromARGB(110, 238, 208, 132);

  // Textos
  static const Color textoPrimario = Color.fromARGB(255, 48, 44, 29);
  static const Color textoSecundario = Color.fromARGB(255, 138, 131, 108);
  static const Color textoClaro = Color.fromARGB(255, 248, 248, 248);

  // Popups e destaques
  static const Color popUp = Color.fromARGB(255, 170, 163, 101);

  // Divisores e sombras
  static const Color divisor = Color.fromARGB(255, 248, 242, 161);
  static const Color sombra = Color.fromARGB(42, 48, 48, 39);

  // Ícones bottom navigation
  static const Color iconsAtivosColor = Color.fromARGB(172, 231, 201, 94);
  static const Color iconsInativosColor = Color.fromARGB(172, 237, 233, 220);

  // Botões específicos
  static const Color botaoPresente = Color.fromARGB(219, 131, 185, 5);
  static const Color botaoFalta = Color.fromARGB(208, 237, 114, 20);

  // Status
  static const Color sucesso = Color(0xFF6DB89A);
  static const Color alerta = Color(0xFFE8C57A);
  static const Color erro = Color(0xFFE87A7A);

  //Status Aula
  static const Color ativo = Color.fromARGB(255, 53, 182, 66);
  static const Color em_andamento = Color.fromARGB(255, 237, 195, 7);
  static const Color lotado = Color.fromARGB(151, 255, 0, 0);
}

/// Espaçamentos da aplicação
class AppSpacing {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;
  static const double xxxl = 64.0;

  // Widget-based spacing for use in widget lists
  static Widget get gapXs => SizedBox(height: xs);
  static Widget get gapSm => SizedBox(height: sm);
  static Widget get gapMd => SizedBox(height: md);
  static Widget get gapLg => SizedBox(height: lg);
  static Widget get gapXl => SizedBox(height: xl);
  static Widget get gapXxl => SizedBox(height: xxl);

  static const EdgeInsets cardPadding = EdgeInsets.all(lg);
  static const EdgeInsets cardPaddingLarge = EdgeInsets.all(xl);
  static const EdgeInsets screenPadding = EdgeInsets.all(lg);
  static const EdgeInsets screenPaddingHorizontal = EdgeInsets.symmetric(horizontal: lg);

  // Widget-based horizontal spacing
  static Widget get gapSmHorizontal => SizedBox(width: sm);
  static Widget get gapMdHorizontal => SizedBox(width: md);
  static Widget get gapLgHorizontal => SizedBox(width: lg);
}

/// Bordas da aplicação
class AppBorders {
  static const double _radiusSmall = 8.0;
  static const double _radiusMedium = 12.0;
  static const double _radiusLarge = 16.0;
  static const double _radiusXLarge = 20.0;
  static const double _radiusXXLarge = 24.0;

  // Double values for padding calculations
  static double get radiusSmallValue => _radiusSmall;
  static double get radiusMediumValue => _radiusMedium;
  static double get radiusLargeValue => _radiusLarge;
  static double get radiusXLargeValue => _radiusXLarge;
  static double get radiusXXLargeValue => _radiusXXLarge;

  // BorderRadius objects for direct use (matching old API)
  static BorderRadius get radiusSmall => BorderRadius.circular(_radiusSmall);
  static BorderRadius get radiusMedium => BorderRadius.circular(_radiusMedium);
  static BorderRadius get radiusLarge => BorderRadius.circular(_radiusLarge);
  static BorderRadius get radiusXLarge => BorderRadius.circular(_radiusXLarge);
  static BorderRadius get radiusXXLarge => BorderRadius.circular(_radiusXXLarge);

  static final RoundedRectangleBorder cardShape = RoundedRectangleBorder(
    borderRadius: radiusLarge,
  );

  static final RoundedRectangleBorder buttonShape = RoundedRectangleBorder(
    borderRadius: radiusMedium,
  );

  static final RoundedRectangleBorder inputShape = RoundedRectangleBorder(
    borderRadius: radiusSmall,
  );
}

/// Sombras da aplicação
class AppShadows {
  static const BoxShadow _cardShadow = BoxShadow(
    color: Color(0x0A000000),
    blurRadius: 10,
    offset: Offset(0, 4),
  );

  static const BoxShadow _cardShadowSmall = BoxShadow(
    color: Color(0x05000000),
    blurRadius: 6,
    offset: Offset(0, 2),
  );

  static const BoxShadow buttonShadow = BoxShadow(
    color: Color(0x0A000000),
    blurRadius: 4,
    offset: Offset(0, 2),
  );

  static const BoxShadow modalShadow = BoxShadow(
    color: Color(0x1A000000),
    blurRadius: 20,
    offset: Offset(0, 10),
  );

  static const BoxShadow elevatedShadow = BoxShadow(
    color: Color(0x1A000000),
    blurRadius: 15,
    offset: Offset(0, 5),
  );

  // Return List<BoxShadow> for direct use (matching old API)
  static List<BoxShadow> get cardShadow => [_cardShadow];
  static List<BoxShadow> get cardShadowSmall => [_cardShadowSmall];
  static List<BoxShadow> get elevatedShadowList => [elevatedShadow];
}

/// Tipografia da aplicação
class AppTypography {
  // Font weights
  static const FontWeight fontWeightBold = FontWeight.bold;
  static const FontWeight fontWeightSemiBold = FontWeight.w600;
  static const FontWeight fontWeightMedium = FontWeight.w500;

  // Font sizes
  static const double fontSizeH2 = 32.0;
  static const double fontSizeH3 = 28.0;
  static const double fontSizeH4 = 24.0;
  static const double fontSizeMd = 16.0;
  static const double fontSizeSm = 14.0;

  static const TextStyle displayLarge = TextStyle(
    fontSize: 57,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.25,
  );

  static const TextStyle displayMedium = TextStyle(
    fontSize: 45,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle displaySmall = TextStyle(
    fontSize: 36,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle headline = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle titleLarge = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle titleMedium = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle titleSmall = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
  );
}
