// flutter run -d web-server --web-port 8080 --web-hostname 172.30.134.63

List<String> get listNames => [
      'Companies',
      'Employee Places',
      'Job Titles',
      'Levels',
      'Modules',
      'Projects',
      'Reference Types',
      'Statuses',
      'Structure Types',
      'System Designations',
      'Functional Areas',
      'Areas',
    ];

List<String> valueTableColumnHeadList = [
  'id',
  'stageId',
  'Employee Id',
  'Assigned date time',
  'Note',
  'Submit date time',
];

List<Map<String, dynamic>> stageDetailsList = [
  {
    'name': 'Importing',
    'staff job': 'Importer',
    'columns': <String>['Weight', 'Phase'],
  },
  {
    'name': 'Modelling',
    'staff job': 'Designers',
    'columns': <String>['Weight', 'GAS', 'SFD', 'DTL'],
  },
  {
    'name': 'Drafting',
    'staff job': 'Drafters',
    'columns': <String>['Weight', 'GAS', 'SFD', 'DTL', 'File Names'],
  },
  {
    'name': 'Checking',
    'get files': 'Get whitecopies',
    'staff job': 'Checkers',
    'columns': <String>['GAS', 'SFD', 'DTL', 'File Names'],
  },
  {
    'name': 'Back Drafting',
    'get files': 'Get checkprints',
    'staff job': 'Back Drafters',
    'columns': ['File Names'],
  },
  {
    'name': 'Back Checking',
    'get files': 'Get checkprints',
    'staff job': 'Back Checkers',
    'columns': ['File Names', "Is Commented"],
  },
  {
    'name': 'Reviewing',
    'get files': 'Get checkprints',
    'staff job': 'Reviewer',
    'columns': ['File Names', "Is Commented"],
  },
  {
    'name': 'Filing',
    'staff job': 'Filing resp. person',
    'columns': ['File Names'],
    'files': {
      'columns': ['File', 'Mark', 'Quantity'],
      'rowsIds': [
        'General Arrangement Drawing - .dwg',
        'General Arrangement Drawing - .pdf',
        'Assembly Drawings - .dwg',
        'Assembly Drawings - .pdf',
        'Single Part Drawings - .dwg',
        'Single Part Drawings - .pdf',
        'Weld Report - .csv',
        'MTO Report - .csv',
        'Drawing List - .csv',
        'Weld Index - .pdf',
        '3D file export - .dwg',
        '3D file export - .ifc',
      ]
    },
  },
  {
    'name': 'Nesting Box',
    'get files': 'Original Files',
    'staff job': 'Nesting Draftsman',
    'columns': <String>[],
  },
];
