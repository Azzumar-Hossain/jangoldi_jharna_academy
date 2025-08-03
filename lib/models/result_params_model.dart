// result_params.dart
class ResultParams {
  final String userName;
  final String selectedTermId;

  ResultParams({required this.userName, required this.selectedTermId});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is ResultParams &&
              runtimeType == other.runtimeType &&
              userName == other.userName &&
              selectedTermId == other.selectedTermId;

  @override
  int get hashCode => userName.hashCode ^ selectedTermId.hashCode;
}
