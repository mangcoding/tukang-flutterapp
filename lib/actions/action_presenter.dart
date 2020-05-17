import 'package:call_tukang/data/rest_ds.dart';
import 'dart:convert';

abstract class ActionScreenContract {
  void onActionSuccess(dynamic resp);
  void onActionError(dynamic error);
}

class ActionScreenPresenter {
  ActionScreenContract _view;
  RestDatasource api = new RestDatasource();
  final JsonDecoder _decoder = new JsonDecoder();

  ActionScreenPresenter(this._view);

  doLogin(String username, String password) {
    api.login(username, password)
      .then((response) async {
        _view.onActionSuccess(response["result"]);
      })
      .catchError((onError) async {
        String errMsg = onError.toString().replaceFirst(new RegExp(r'Exception: '), '');
        var error = _decoder.convert(errMsg);
        _view.onActionError(error);
      });
  }

  doSignUp(dynamic datas) {
    api.register(datas)
      .then((response) async {
        _view.onActionSuccess(response["result"]);
      })
      .catchError((onError) async {
        String errMsg = onError.toString().replaceFirst(new RegExp(r'Exception: '), '');
        var error = _decoder.convert(errMsg);
        _view.onActionError(error);
      });
  }

  getService(String token) {
    api.services(token)
    .then((response) async {
      _view.onActionSuccess(response);
    })
    .catchError((onError) async {
      String errMsg = onError.toString().replaceFirst(new RegExp(r'Exception: '), '');
      var error = _decoder.convert(errMsg);
      _view.onActionError(error);
    });
  }
  doOrder(dynamic datas, token) {
    api.order(datas, token)
      .then((response) async {
        _view.onActionSuccess(response);
      })
      .catchError((onError) async {
        String errMsg = onError.toString().replaceFirst(new RegExp(r'Exception: '), '');
        var error = _decoder.convert(errMsg);
        _view.onActionError(error);
      });
  }
}