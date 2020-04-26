import 'package:call_tukang/data/rest_ds.dart';

abstract class ActionScreenContract {
  void onActionSuccess(dynamic resp);
  void onActionError(dynamic error);
}

class ActionScreenPresenter {
  ActionScreenContract _view;
  RestDatasource api = new RestDatasource();
  ActionScreenPresenter(this._view);
  
  doLogin(String username, String password) {
    // print("Login dengan "+username+ " "+password);
    api
        .login(username, password)
        .then((response) async {
          _view.onActionSuccess(response["result"]);
        })
        .catchError((onError) => _view.onActionError(onError));
  }
  doSignUp(dynamic datas) {
    // print("Login dengan "+username+ " "+password);
    api
        .register(datas)
        .then((response) async {
          _view.onActionSuccess(response["result"]);
        })
        .catchError((onError) => _view.onActionError(onError));
  }
}