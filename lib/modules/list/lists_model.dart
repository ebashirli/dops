class ListsModel {
  String id;
  List<dynamic>? companies;
  List<dynamic>? employeePlaces;
  List<dynamic>? jobTitles;
  List<dynamic>? levels;
  List<dynamic>? modules;
  List<dynamic>? projects;
  List<dynamic>? referenceTypes;
  List<dynamic>? statuses;
  List<dynamic>? structureTypes;
  List<dynamic>? systemDesignations;
  List<dynamic>? functionalAreas;
  List<dynamic>? areas;
  List<dynamic>? drawingTags;
  ListsModel({
    this.id = 'list',
    this.companies,
    this.employeePlaces,
    this.jobTitles,
    this.levels,
    this.modules,
    this.projects,
    this.referenceTypes,
    this.statuses,
    this.structureTypes,
    this.systemDesignations,
    this.functionalAreas,
    this.areas,
    this.drawingTags,
  });

  Map<String, dynamic> toMap() {
    return {
      'companies': companies,
      'employeePlaces': employeePlaces,
      'jobTitles': jobTitles,
      'levels': levels,
      'modules': modules,
      'projects': projects,
      'referenceTypes': referenceTypes,
      'statuses': statuses,
      'structureTypes': structureTypes,
      'systemDesignations': systemDesignations,
      'functionalAreas': functionalAreas,
      'areas': areas,
      'drawingTags': drawingTags,
    };
  }

  factory ListsModel.fromMap(Map<String, dynamic> map) {
    return ListsModel(
      id: 'list',
      companies: map['companies'],
      employeePlaces: map['employeePlaces'],
      jobTitles: map['jobTitles'],
      levels: map['levels'],
      modules: map['modules'],
      projects: map['projects'],
      referenceTypes: map['referenceTypes'],
      statuses: map['statuses'],
      structureTypes: map['structureTypes'],
      systemDesignations: map['systemDesignations'],
      functionalAreas: map['functionalAreas'],
      areas: map['areas'],
      drawingTags: map['drawingTags'],
    );
  }
}
