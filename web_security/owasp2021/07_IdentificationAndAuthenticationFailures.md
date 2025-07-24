# OWASP Top 10 2021 – A07 Identification and Authentication Failures

## 概要
ユーザの識別 (ID) および認証 (AuthN) プロセスにおける設計・実装ミス。パスワードポリシー不備、多要素認証不足、セッション管理ミスなどが含まれる。

## 代表的な攻撃例
### 1. 資格情報詰め込み (Credential Stuffing)
漏えいパスワードリストで大量ログイン試行しアカウント占拠。

### 2. 長寿命 JWT の盗難
無期限トークンを盗まれ、恒久的に乗っ取られる。

### 3. パスワードリセットフローの不備
メールに送られた token が予測容易 / 期限なし。

## 影響
- アカウント乗っ取り
- 不正決済・情報漏えい

## セキュア設計 / 実装ガイド
1. **多要素認証 (MFA)** を導入 (TOTP, WebAuthn)。
2. パスワードは 12 文字以上 & 複雑さ要件、`bcrypt` などでハッシュ化。
3. JWT / セッションは短い有効期限 + リフレッシュトークン方式。
4. 同時セッション数やログイン試行回数を制限 (Rate Limit)。

## フロントエンド開発者の観点
- Cookie で保管する場合 `SameSite=Lax/Strict`, `HttpOnly`, `Secure` を設定。
- トークンを LocalStorage に保存しない。

## バックエンド開発者の観点
- パスワードリスト攻撃に対する遅延レスポンスや reCAPTCHA。
- `Set-Cookie` に `__Host-` or `__Secure-` プレフィックスを活用。
- セッション失効 API (logout) を実装。

## コードスニペット (Express JWT)
```js
const token = jwt.sign({ uid: user.id }, process.env.JWT_SECRET, {
  expiresIn: '15m',
});

res.cookie('access_token', token, {
  httpOnly: true,
  sameSite: 'lax',
  secure: true,
  maxAge: 15 * 60 * 1000,
});
```

## 参考資料
- OWASP Authentication Cheat Sheet
- NIST 800-63B
- WebAuthn Level 2 Spec
