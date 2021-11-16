part of 'app_pages.dart';

abstract class Routes {
  Routes._();

  static const HOME = _Paths.HOME;
  static const REFERENCE_DOCUMENT = _Paths.REFERENCE_DOCUMENT;
  static const ACTIVITY = _Paths.ACTIVITY;
  static const DROPDOWN_SOURCE_LISTS = _Paths.DROPDOWN_SOURCE_LISTS;
  static const STAFF = _Paths.STAFF;
  static const TASKS = _Paths.TASKS;
  static const FOLLOWING = _Paths.FOLLOWING;
}

abstract class _Paths {
  static const HOME = '/home';
  static const REFERENCE_DOCUMENT = '/reference_document';
  static const ACTIVITY = '/activity';
  static const DROPDOWN_SOURCE_LISTS = '/dropdown_source_lists';
  static const STAFF = '/staff';
  static const TASKS = '/tasks';
  static const FOLLOWING = '/following';
}
