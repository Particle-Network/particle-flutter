class JSONField {
  //Specify the parse field name
  final String? name;

  //Whether to participate in toJson
  final bool? serialize;

  //Whether to participate in fromMap
  final bool? deserialize;

  const JSONField({this.name, this.serialize, this.deserialize});
}
