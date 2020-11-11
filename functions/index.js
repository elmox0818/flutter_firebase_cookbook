// functions/index.js

const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp();

// ①followFromコレクションへの書き込みをトリガーにしてFunctions側でユーザドキュメントを更新
exports.createFollower = functions.firestore
  .document('users/{userId}/followFrom/{followUserId}')
  .onCreate((snapshot, context) => {
    // 書き込まれた値は取得可能
    const newValue = snapshot.data();
    console.log('新規作成された値', newValue);
    const userRef = admin
      .firestore()
      .collection('users')
      .doc(context.params.userId);
    userRef
      .get()
      .then(function (userDoc) {
        var follower = userDoc.data().follower;
        // 通知データも追加
        userRef.collection('notifications').add({
          createdAt: admin.firestore.FieldValue.serverTimestamp(),
          body: 'フォローされました！',
        });
        if (follower) {
          follower.push(context.params.followUserId);
          userRef.update({
            follower: follower,
          });
          return;
        } else {
          userRef.update({
            follower: [context.params.followUserId],
          });
          return;
        }
      })
      .catch((err) => {
        return console.log(err);
      });
  });

exports.deleteFollower = functions.firestore
  .document('users/{userId}/followFrom/{followUserId}')
  .onDelete((snapshot, context) => {
    const deletedValue = snapshot.data();
    const userRef = admin
      .firestore()
      .collection('users')
      .doc(context.params.userId);
    userRef
      .get()
      .then(function (userDoc) {
        var follower = userDoc.data().follower;
        if (follower) {
          follower = follower.filter((f) => f !== context.params.followUserId);
          userRef.update({
            follower: follower,
          });
          return;
        } else {
          return;
        }
      })
      .catch((err) => {
        return console.log(err);
      });
  });

// ②新規通知のデータが書き込まれた時に通知をする
exports.createNotification = functions.firestore
  .document('users/{userId}/notifications/{notificationId}')
  .onCreate((snapshot, context) => {
    const newValue = snapshot.data();
    console.log('通知データ', newValue);
    // userIDとトピックにメッセージを送信
    admin.messaging().sendToTopic(context.params.userId, {
      notification: {
        title: '通知テスト',
        body: newValue.body,
        clickAction: 'FLUTTER_NOTIFICATION_CLICK',
      },
    });
  });
