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

List<String> valueTableCommonColumnHeadList = [
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
    'form fields': <String>['Weight', 'Phase'],
  },
  {
    'name': 'Modelling',
    'staff job': 'Designers',
    'form fields': <String>['Weight', 'GAS', 'SFD', 'DTL'],
  },
  {
    'name': 'Drafting',
    'staff job': 'Drafters',
    'form fields': <String>['Weight', 'GAS', 'SFD', 'DTL'],
    'file names': true,
  },
  {
    'name': 'Checking',
    'get files': 'Get whitecopies',
    'staff job': 'Checkers',
    'form fields': <String>['GAS', 'SFD', 'DTL'],
    'file names': true,
  },
  {
    'name': 'Back Drafting',
    'get files': 'Get checkprints',
    'staff job': 'Back Drafters',
    'form fields': <String>[],
    'file names': true,
  },
  {
    'name': 'Back Checking',
    'get files': 'Get checkprints',
    'staff job': 'Back Checkers',
    'form fields': <String>[],
    'file names': true,
    "comment": true,
  },
  {
    'name': 'Reviewing',
    'get files': 'Get checkprints',
    'staff job': 'Reviewer',
    'form fields': <String>[],
    'file names': true,
    "comment": true,
  },
  {
    'name': 'Filing',
    'staff job': 'Filing resp. person',
    'form fields': <String>[],
    'file names': true,
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
    'form fields': <String>[],
  },
  {
    'name': 'Issuing',
    'staff job': 'Coordinator',
    'form fields': <String>[],
  },
];
