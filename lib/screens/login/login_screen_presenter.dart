import 'package:call_tukang/data/rest_ds.dart';

abstract class LoginScreenContract {
  void onLoginSuccess(dynamic resp);
  void onLoginError(dynamic error);
}

class LoginScreenPresenter {
  LoginScreenContract _view;
  RestDatasource api = new RestDatasource();
  LoginScreenPresenter(this._view);

  doLogin(String username, String password) {
    // print("Login dengan "+username+ " "+password);
    api
        .login(username, password)
        .then((response) => _view.onLoginSuccess(response))
        .catchError((onError) => _view.onLoginError(onError));
  }
}