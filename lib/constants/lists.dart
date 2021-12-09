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

List<String> stageNames = [
  'Importing',
  'Designing',
  'Drafting',
  'Checking',
  'Back Drafting',
  'Back Checking',
  'Reviewer',
  'Filing ',
  'Nesting Box',
];

List<Map<String, dynamic>> stageDetailsList = [
  {
    'name': 'Importing',
    'staff job': 'Importer',
    'number fields': {
      'suffix': 'Initial quantity',
      'name': [
        'Weight',
        'Phase',
      ],
    },
    'string fields': ['Note'],
  },
  {
    'name': 'Modelling',
    'staff job': 'Designers',
    'number fields': {
      'suffix': 'Planned quantity',
      'name': [
        'Weight',
        'GAS',
        'SFD',
        'DTL',
      ],
    },
    'string fields': ['Note'],
  },
  {
    'name': 'Drafting',
    'staff job': 'Drafters',
    'isThereFiles': true,
    'number fields': {
      'suffix': 'Actual quantity',
      'name': [
        'Weight',
        'GAS',
        'SFD',
        'DTL',
      ],
    },
    'string fields': ['Note'],
  },
  {
    'name': 'Checking',
    'get files': 'Get whitecopies',
    'staff job': 'Checkers',
    'number fields': {
      'suffix': 'Attached',
      'name': [
        'GAS',
        'SFD',
        'DTL',
      ],
    },
    'isThereFiles': true,
    'string fields': ['Note'],
  },
  {
    'name': 'Back Drafting',
    'get files': 'Get checkprints',
    'staff job': 'Back Drafters',
    'number fields': {
      'suffix': '',
      'name': [],
    },
    'isThereFiles': true,
    'string fields': ['Note'],
  },
  {
    'name': 'Back Checking',
    'get files': 'Get checkprints',
    'staff job': 'Back Checkers',
    'number fields': {
      'suffix': '',
      'name': [],
    },
    'isThereFiles': true,
    'string fields': ['Note'],
  },
  {
    'name': 'Reviewing',
    'get files': 'Get checkprints',
    'staff job': 'Reviewer',
    'number fields': {
      'suffix': '',
      'name': [],
    },
    'isThereFiles': true,
    'string fields': ['Note'],
  },
  {
    'name': 'Filing',
    'staff job': 'Filing resp. person',
    'number fields': {
      'suffix': '',
      'name': [],
    },
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
    'isThereFiles': true,
    'string fields': ['Note'],
  },
  {
    'name': 'Nesting Box',
    'get files': 'Original Files',
    'staff job': 'Nesting Draftsman',
    'number fields': {
      'suffix': '',
      'name': ['Lot number'],
    },
    'string fields': ['Note'],
  },
];
