// lib/screens/password_change_screen.dart

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flushbar/flushbar.dart';

class PasswordChangeScreen extends StatefulWidget {
  static const routeName = "/password_change";

  @override
  _PasswordChangeScreenState createState() => _PasswordChangeScreenState();
}

class _PasswordChangeScreenState extends State<PasswordChangeScreen> {
  final _formKey = GlobalKey<FormState>();

  var _isLoading = false;
  var _oldPassword = "";
  var _newPassword1 = "";
  var _newPassword2 = "";

  Future<void> _changePassword() async {
    // 登録結果を格納する
    // バリデーションを実行
    final isValid = _formKey.currentState.validate();
    // キーボードを閉じる
    FocusScope.of(context).unfocus();

    // バリデーションに問題がなければ登録
    if (isValid) {
      try {
        setState(() {
          _isLoading = true;
        });
        // formの内容を保存
        _formKey.currentState.save();
        // パスワードの一致を確認
        if (_newPassword1 != _newPassword2) {
          setState(() {
            _isLoading = false;
          });
          _showErrorFlash("パスワードが一致しません");
          return;
        }
        // パスワード変更を実行箇所
        User user = FirebaseAuth.instance.currentUser;
        // 現在のユーザを再度認証
        UserCredential authResult = await user.reauthenticateWithCredential(
            EmailAuthProvider.credential(
                email: user.email, password: _oldPassword));
        // 認証したユーザでパスワード変更を実施
        await authResult.user.updatePassword(_newPassword1);
        Navigator.pop(context);
      } on PlatformException catch (err) {
        var message = 'エラーが発生しました。認証情報を確認してください。';
        if (err.message != null) {
          message = err.message;
        }
        _showErrorFlash(message);
        setState(() {
          _isLoading = false;
        });
      } catch (err) {
        print(err);
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showErrorFlash(String message) {
    Flushbar(
      message: message,
      backgroundColor: Colors.red,
      margin: EdgeInsets.all(8),
      borderRadius: 8,
      duration: Duration(seconds: 3),
    )..show(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Card(
        child: Padding(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // メールアドレスの入力フィールド
                TextFormField(
                  key: ValueKey("oldPassword"),
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(labelText: "古いパスワード"),
                  obscureText: true,
                  validator: (value) {
                    if (value.isEmpty || value.length < 4) {
                      return '最低4文字以上は入力してください';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _oldPassword = value;
                  },
                ),
                // パスワード1の入力フィールド
                TextFormField(
                  key: ValueKey("newPassword1"),
                  decoration: InputDecoration(labelText: "新しいパスワード"),
                  obscureText: true,
                  validator: (value) {
                    if (value.isEmpty || value.length < 4) {
                      return '最低4文字以上は入力してください';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _newPassword1 = value;
                  },
                ),
                // パスワード2の入力フィールド
                TextFormField(
                  key: ValueKey("password2"),
                  decoration: InputDecoration(labelText: "新しいパスワード確認"),
                  obscureText: true,
                  validator: (value) {
                    if (value.isEmpty || value.length < 4) {
                      return '最低4文字以上は入力してください';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _newPassword2 = value;
                  },
                ),
                SizedBox(
                  height: 12,
                ),
                _isLoading
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : RaisedButton(
                        child: Text("変更"),
                        onPressed: _changePassword,
                      )
              ],
            ),
          ),
          padding: EdgeInsets.all(16),
        ),
      ),
    );
  }
}
