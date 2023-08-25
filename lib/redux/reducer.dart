class AppState {
  int rtvCode;

  AppState({required this.rtvCode});
}

class SaveRTVCodeAction {
  final int rtvCode;

  SaveRTVCodeAction(this.rtvCode);
}
AppState appReducer(AppState state, dynamic action) {
  if (action is SaveRTVCodeAction) {
    return AppState(rtvCode: action.rtvCode);
  }
  return state;
}