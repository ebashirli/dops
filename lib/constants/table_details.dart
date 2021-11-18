import 'package:recase/recase.dart';

Map<String, List<String>> tableColNames = {
  'reference document': [
    'id',
    'Project',
    'Reference Type',
    'Module Name',
    'Document number',
    'Revision code',
    'Title',
    'Transmittal number',
    'Received date',
    'Action required or Next',
    'Assigned tasks',
  ],
  'activity': [
    'id',
    'Activity Id',
    'Activity Name',
    'Module Name',
    'Priority',
    'Coefficient',
    'Current Priority',
    'Budgeted Labor Units',
    'Start Date',
    'Finish Date',
    'Cumulative',
    'Assigned Tasks',
  ],
  'staff': [
    'id',
    'Badge No',
    'Name',
    'Surname',
    'Patronymic',
    'Full name',
    'Initial',
    'System Designation',
    'Job Title',
    'E-mail',
    'Company',
    'Date of Birth',
    'Home Address',
    'Start date',
    'Current place',
    'Contract Finish Date',
    'Contact',
    'Emergency Contact',
    'Emergency Contact Name',
    'Note'
  ],
  'task': [
    'id',
    'Priority',
    'Activity Code',
    'Drawing Number',
    'Cover Sheet Revision',
    'Drawing Title',
    'Module',
    'Issue Type',
    'Revision Number',
    'Percentage',
    'Revision Status',
    'Level',
    'Structure Type',
    'Design Drawings',
    'Change Number',
    'Task Create Date',
  ],
};

List<String> mapPropNamesGetter(String tableName) {
  return tableColNames[tableName]!
      .map((colName) => ReCase(colName).camelCase)
      .toList();
}
