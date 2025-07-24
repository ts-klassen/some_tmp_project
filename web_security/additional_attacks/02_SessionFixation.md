# セッション固定攻撃 (Session Fixation)

## 概要
攻撃者があらかじめ生成したセッション ID を被害者に使用させ、ログイン後も同じ ID が継続することでアカウントを乗っ取る攻撃手法。

## 攻撃の流れ
1. 攻撃者がアプリにアクセスし、有効なセッション ID（例: `PHPSESSID=abc123`）を取得。
2. フィッシングリンクや XSS を利用して、被害者ブラウザの Cookie にこの ID を設定させる。
3. 被害者が通常のログインを行うが、セッション ID は攻撃者指定のまま。
4. 攻撃者は同じ ID を用いてアカウントにアクセスできる。

## 影響
・アカウント乗っ取り、個人情報漏えい、権限悪用。

## 主な防御策
1. **ログイン成功時に必ずセッション ID を再生成** し、古い ID を無効化する。
2. Cookie に `HttpOnly`、`Secure`、`SameSite` を付与し、XSS や送信制限を強化する。
3. URL パラメータでセッション ID を受け付けない設計にする。
4. セッション ID に推測困難な十分な長さと乱数性を持たせる。

## コード例（Express + express-session）
```js
app.post('/login', async (req, res) => {
  const user = await authUser(req.body);
  if (!user) return res.status(401).send('fail');

  // セッション固定対策: ID 再生成
  req.session.regenerate(err => {
    if (err) return res.status(500).send('error');
    req.session.userId = user.id;
    res.redirect('/mypage');
  });
});
```

## 参考文献
・OWASP Session Management Cheat Sheet  
・RFC 6265 HTTP State Management Mechanism  
