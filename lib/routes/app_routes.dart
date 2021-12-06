part of 'app_pages.dart';

abstract class Routes {
  Routes._();

  static const SPLASH = _Paths.SPLASH;
  static const HOME = _Paths.HOME;
  static const UNKNOWN = _Paths.UNKNOWN;
  static const LOGIN = _Paths.LOGIN;
  static const REFERENCE_DOCUMENT = _Paths.REFERENCE_DOCUMENT;
  static const ACTIVITY = _Paths.ACTIVITY;
  static const DROPDOWN_SOURCE_LISTS = _Paths.DROPDOWN_SOURCE_LISTS;
  static const STAFF = _Paths.STAFF;
  static const TASKS = _Paths.TASKS;
  static const STAGES = _Paths.STAGES;
}

abstract class _Paths {
  static const SPLASH = '/main';
  static const UNKNOWN = '/unknown';
  static const LOGIN = '/login';
  static const HOME = '/home';
  static const REFERENCE_DOCUMENT = '/reference_document';
  static const ACTIVITY = '/activity';
  static const DROPDOWN_SOURCE_LISTS = '/dropdown_source_lists';
  static const STAFF = '/staff';
  static const TASKS = '/tasks';
  static const STAGES = '/stages';
}
