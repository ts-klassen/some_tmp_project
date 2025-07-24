# Open Redirect（オープンリダイレクト）

## 概要
アプリが受け取った URL を検証せず 3xx リダイレクトに使用すると、攻撃者が任意の悪性サイトへユーザを転送できる。フィッシング、OAuth 連携のハイジャック、XSS 連鎖などの導線として利用される。

## 一般的な攻撃シナリオ
1. 正規ドメイン上の脆弱エンドポイント `/redirect?url=https://evil.example` を生成。
2. ユーザは信頼できるドメインだと誤認しクリック。
3. 一旦正規サイトにアクセス後、即座に悪意サイトへ 302 転送される。

## OAuth / SSO ハイジャック例
1. サービスは `https://service.example/auth/callback` を `redirect_uri` として IdP に登録。  
2. 攻撃者は Open Redirect を悪用し、登録済み URI 内でさらに外部へ飛ばす URL を用意。

   `https://service.example/redirect?url=https://evil.example/callback`

3. 認可コードフロー中、IdP は登録済み URI へ `code` を付与してリダイレクト。  
4. 302 が発生し `code` がそのまま攻撃者ドメインへ到達。  
5. 攻撃者は `code` を使いアクセストークンを交換、ユーザになりすます。

## 影響
・フィッシング成功率の大幅上昇（正規ドメインを踏み台にするため信頼度が高い）  
・OAuth / SSO アカウントの乗っ取り  
・XSS など他脆弱性とのコンボ攻撃

## 防御策
1. リダイレクト先は完全 **ホワイトリスト**（ドメイン・パス）で管理する。  
2. 原則として相対パスのみを許可し、外部 URL を受け付けない設計にする。  
3. エラー時は固定ページへ遷移し、入力値は表示しない。  
4. OAuth クライアントでは `redirect_uri` を事前登録し、**完全一致**か PKCE を併用してエンドポイントを固定する。

## サンプルコード（Node.js）
```js
const ALLOW_PATHS = ['/dashboard', '/settings'];

app.get('/redirect', (req, res) => {
  const target = req.query.url || '/';
  try {
    // 外部 URL を禁止し、相対パスのみ許可
    if (target.startsWith('http')) throw new Error('external');
    if (!ALLOW_PATHS.includes(target)) throw new Error('deny');
    res.redirect(target);
  } catch {
    res.redirect('/');
  }
});
```

## 参考
・OWASP Unvalidated Redirects and Forwards Cheat Sheet  
・OAuth 2.0 Security Best Current Practice (RFC 9321)  
