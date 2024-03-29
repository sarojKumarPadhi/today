// class TanentsModel{
//   String name;
//   String id;

//   TanentsModel(this.name, this.id);
// }

class TanentsModel {
  String name;
  String id;

  TanentsModel(this.name, this.id);

  factory TanentsModel.fromJson(Map<String, dynamic> json) {
    return TanentsModel(
      json['name'] ?? '', // 'name' is the key for the tenant name
      json['id'] ?? '', // 'id' is the key for the tenant id
    );
  }
}
