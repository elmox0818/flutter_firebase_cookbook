// lib/widgets/auth/email_sign_up_form.dart

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../helpers/alert_helpers.dart';

class EmailSignUpForm extends StatefulWidget {
  @override
  _EmailSignUpFormState createState() => _EmailSignUpFormState();
}

class _EmailSignUpFormState extends State<EmailSignUpForm> {
  final AlertHelpers alert = AlertHelpers();
  final _formKey = GlobalKey<FormState>();

  var _isLoading = false;
  var _email = "";
  var _password1 = "";
  var _password2 = "";

  Future<void> _signUp() async {
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
        if (_password1 != _password2) {
          setState(() {
            _isLoading = false;
          });
          alert.showFlash(context, "パスワードが一致しません", Colors.red);
          return;
        }
        // サインアップを実行
        UserCredential authResult = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: _email, password: _password1);
        // 登録に成功したユーザ情情報も取得可能 -> Firestoreに登録
        FirebaseFirestore.instance
            .collection("users")
            .doc(authResult.user.uid)
            .set({
          "email": authResult.user.email,
        });
        // 有効なメールアドレスか確認するためのメールを送信する;
        authResult.user.sendEmailVerification();
        alert.showFlash(context, "メールアドレス確認用のメールを送信しました。", Colors.blue);
      } on PlatformException catch (err) {
        var message = 'エラーが発生しました。認証情報を確認してください。';
        if (err.message != null) {
          message = err.message;
        }
        alert.showFlash(context, message, Colors.red);
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

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // メールアドレスの入力フィールド
              TextFormField(
                key: ValueKey("email"),
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(labelText: "メールアドレス"),
                validator: (value) {
                  if (!EmailValidator.validate(value)) {
                    return "正しいメールアドレスを入力してください";
                  }
                  return null;
                },
                onSaved: (value) {
                  _email = value;
                },
              ),
              // パスワード1の入力フィールド
              TextFormField(
                key: ValueKey("password1"),
                decoration: InputDecoration(labelText: "パスワード"),
                obscureText: true,
                validator: (value) {
                  if (value.isEmpty || value.length < 4) {
                    return '最低4文字以上は入力してください';
                  }
                  return null;
                },
                onSaved: (value) {
                  _password1 = value;
                },
              ),
              // パスワード2の入力フィールド
              TextFormField(
                key: ValueKey("password2"),
                decoration: InputDecoration(labelText: "パスワード確認"),
                obscureText: true,
                validator: (value) {
                  if (value.isEmpty || value.length < 4) {
                    return '最低4文字以上は入力してください';
                  }
                  return null;
                },
                onSaved: (value) {
                  _password2 = value;
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
                      child: Text("登録"),
                      onPressed: _signUp,
                    )
            ],
          ),
        ),
        padding: EdgeInsets.all(16),
      ),
    );
  }
}
