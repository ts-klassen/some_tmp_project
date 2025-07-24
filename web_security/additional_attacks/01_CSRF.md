# CSRF (Cross-Site Request Forgery)

## 概要
ユーザがログイン済みの状態を悪用し、別ドメインに仕込まれたリクエストを被害サイトへ送信させる攻撃。振込やパスワード変更などの「状態変更系」操作をユーザ本人の権限で実行させられる。

## 典型的な流れ
1. 被害者が `bank.example` にログインしたまま攻撃者サイトを閲覧する。
2. 攻撃者ページに埋め込まれた HTML もしくは JS が、`https://bank.example/transfer` へ自動で POST を発行する。
3. ブラウザは同一オリジン Cookie を添付するため、サーバは正当なリクエストと判断し送金が完了する。

## 影響
・不正送金、メールアドレス変更、購入処理など、重大な副作用を伴う操作が強制実行される。

## 主な防御策
1. サーバ側で **CSRF トークン** を発行し、リクエストと照合する。
2. Cookie に `SameSite=Lax` 以上を設定してクロスサイト送信を原則ブロックする。
3. `Origin` または `Referer` ヘッダを検証し、想定ドメイン以外を拒否する。
4. GET/HEAD 等の安全メソッドに副作用を持たせない RESTful 設計を徹底する。

## コード例（Express + csurf）
```js
const csrf = require('csurf');
app.use(csrf({ cookie: { sameSite: 'lax', httpOnly: true, secure: true } }));

app.get('/form', (req, res) => {
  res.render('form', { csrfToken: req.csrfToken() });
});

app.post('/transfer', (req, res) => {
  // トークン検証済み
  processTransfer(req.body);
  res.send('ok');
});
```

## 参考文献
・OWASP CSRF Prevention Cheat Sheet  
・RFC 6265bis SameSite 属性  
