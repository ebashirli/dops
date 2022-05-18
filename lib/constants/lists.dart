List<String> get listNames => [
      'Companies',
      'Employee Places',
      'Job Titles',
      'Levels',
      'Modules',
      'Projects',
      'Reference Types',
      'Structure Types',
      'System Designations',
      'Functional Areas',
      'Areas',
      'Drawing Tags'
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
  // 0
  {
    'name': 'Importing',
    'staff job': '3D Admin',
    'form fields': <String>['Weight', 'Phase'],
  },
  // 1
  {
    'name': 'Modelling',
    'staff job': 'Designer',
    'form fields': <String>['Weight', 'GAS', 'SFD', 'DTL'],
  },
  // 2
  {
    'name': 'Drafting',
    'staff job': 'Drafter',
    'form fields': <String>['Weight', 'GAS', 'SFD', 'DTL'],
    'file names': true,
  },
  // 3
  {
    'name': 'Checking',
    'get files': 'Get whitecopies',
    'staff job': 'Checker',
    'form fields': <String>['GAS', 'SFD', 'DTL'],
    'file names': true,
  },
  // 4
  {
    'name': 'Back Drafting',
    'get files': 'Get checkprints',
    'staff job': 'Back Drafter',
    'form fields': <String>[],
    'file names': true,
  },
  // 5
  {
    'name': 'Back Checking',
    'get files': 'Get checkprints',
    'staff job': 'Back Checker',
    'form fields': <String>[],
    'file names': true,
    "comment": true,
  },
  // 6
  {
    'name': 'Reviewing',
    'get files': 'Get checkprints',
    'staff job': 'Reviewer',
    'form fields': <String>[],
    'file names': true,
    "comment": true,
  },
  // 7
  {
    'name': 'Filing',
    'staff job': 'Filing resp. person',
    'form fields': <String>['HOLD'],
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
  // 8
  {
    'name': 'Nesting',
    'get files': 'Original Files',
    'staff job': 'Nesting Draftsman',
    'file names': true,
    'form fields': <String>[],
  },
  // 9
  {
    'name': 'Issuing',
    'staff job': 'Coordinator',
    'form fields': <String>['transmittal'],
  },
];

const List<int> percentages = [
  100,
  100,
  95,
  90,
  87,
  87,
  85,
  82,
  80,
  77,
  75,
  70,
  65,
  50,
  45,
  25,
  20,
  5,
  3,
  1,
  0,
];

Map<String, List<String?>> dropDownMenuLists = {
  'areas': [
    '3-5/A-B',
    '0-3/A-B',
    '0-3/North',
  ],
  'companies': [
    'Azfen',
    'Tekfen Engineering',
    'Wood',
  ],
  'drawingTags': [
    '6A-SHY71175',
    '6A-SHY71176',
    '6A-SHY71177',
  ],
  'employeePlaces': [
    'Office',
    'Home',
    'Left',
    'Transfer',
  ],
  'functionalAreas': [
    'Filter house',
    'Mechanical Workshop',
  ],
  'jobTitles': [
    'Structural Designer',
    'Nesting Draftsman',
    'Structural Checker',
    'Structural Section Leader',
    'Structural Draftsman',
    'Structural Leading Hand',
  ],
  'levels': [
    'Under Deck',
    'Upper Mezz. Deck',
    'Upper Deck',
    'Load-Out Frame',
    'Weather Deck',
    'Cellar Deck',
    'Under Deck',
    'Mezzanine Deck',
    'Common',
    'Skid Deck',
    'Drill Floor',
    'Upper Drill Floor',
    'Lower Mezz. Deck',
    'BOP Deck',
    'Lower Deck',
    'Section 3',
    'Section 1',
    'Section 2',
    'Section 4',
    'Pipe Deck',
    'Valve Access Platform',
    'Derrick',
    'Flare',
    'Living Quarter',
    'Outdoor Meeting Area',
  ],
  'modules': [
    'Topside',
    'Drilling - DES',
    'Topside',
    'Flare',
    'Drilling - MDSM',
    'Drilling - General',
  ],
  'projects': [
    'ACE',
  ],
  'referenceTypes': [
    'Reference Code',
    'Technichal Query',
    'Site Instruction',
    'Constrcution Change Notice',
    'Field Change Notice',
    'Design Drawing',
  ],
  'structureTypes': [
    'Equipment Support',
    'Safety Equipment Support',
    'Equipment Support',
    'Node',
    'Handrail',
    'Grating',
    'Access Platform',
    'Instrument Support',
    'Miscellaneous',
    'Plating',
    'Secondary Steel',
    'Tank&Vessels',
    'Access Hatch',
    'Ladder',
    'Deck Penetrations',
    'Plate Girder Pre-fab',
    'Pipe Support',
    'Cladding',
    'Primary Beam',
    'Beam Penetrations',
    'Stabbing Guides',
    'Temporary Steel',
    'Manhole',
    'Rodding Hatch',
    'Hatch',
    'Drain Box',
    'Hydrant Cabinets',
    'Tertiary Steel',
    'Outfitting Steel',
    'Mechanical Handling',
    'Skid Rail',
    'Stair',
    'Seafastening',
    'Truss',
    'Box Girder',
    'Crane Pedestal',
    'Piperack',
    'Life Raft Support',
    'Cablerack Support',
    'Safety Gate',
    'Standard Drg.',
  ],
  'systemDesignations': []
};

final List<List<String>> filingTypes = [
  [
    'General Arrangement Drawing - .dwg',
    'dwg',
    'gaddwg',
  ],
  [
    'General Arrangement Drawing - .pdf',
    'pdf',
    'gadpdf',
  ],
  [
    'Assembly Drawings - .dwg',
    'dwg',
    'addwg',
  ],
  [
    'Assembly Drawings - .pdf',
    'pdf',
    'adpdf',
  ],
  [
    'Single Part Drawings - .dwg',
    'dwg',
    'spddwg',
  ],
  [
    'Single Part Drawings - .pdf',
    'pdf',
    'spdpdf',
  ],
  [
    'Weld Report - .csv',
    'csv',
    'weldReport',
  ],
  [
    'MTO Report - .csv',
    'csv',
    'mtoReport',
  ],
  [
    'Drawing List - .csv',
    'csv',
    'drawingList',
  ],
  [
    'Weld Index - .pdf',
    'pdf',
    'weldIndex',
  ],
  [
    '3D file export - .dwg',
    'dwg',
    'exptdwg',
  ],
  [
    '3D file export - .ifc',
    'ifc',
    'exptifc',
  ],
];
