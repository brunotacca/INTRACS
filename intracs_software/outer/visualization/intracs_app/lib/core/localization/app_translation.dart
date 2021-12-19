import 'package:intracs_app/core/localization/en_US/en_US.dart';
import 'package:intracs_app/core/localization/pt_BR/pt_BR.dart';

abstract class AppTranslation {
  static Map<String, Map<String, String>> translations = {
    'en_US': enUS,
    'pt_BR': ptBR,
  };
}
