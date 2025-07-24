# OWASP Top 10 2021 – A02 Cryptographic Failures

## 概要
データ機密性・完全性を保護する暗号化の欠如、または不適切な実装による失敗。不充分な TLS 設定、弱い暗号アルゴリズム、鍵管理ミスなどが該当。

## 代表的な攻撃例
### 1. 平文通信
HTTP で認証情報や個人情報を送信し、盗聴可能になる。

### 2. 弱いパスワードハッシュ
`MD5` や `SHA-1` での単純ハッシュにより、レインボーテーブル攻撃で容易に解読される。

### 3. 鍵・証明書のハードコード
リポジトリに API キーや秘密鍵をコミットしてしまい、漏えいにつながる。

## 影響
- パスワード・クレジットカード情報の漏えい
- セッション乗っ取り、なりすまし
- データ改ざん・フィッシング被害

## セキュア設計 / 実装ガイド
1. すべての通信を **TLS1.2+** で暗号化。
2. パスワードは `bcrypt`, `scrypt`, `Argon2` など計算コストが高いハッシュで保存。
3. 秘密鍵・API キーは Secrets Manager/Vault で管理し、コードや Git に置かない。
4. 鍵ローテーション手順を運用設計に組み込む。

## フロントエンド開発者の観点
- fetch/axios の API エンドポイントは常に `https://` に固定。
- `Content-Security-Policy: upgrade-insecure-requests` を有効化。

## バックエンド開発者の観点
- 強力な暗号スイートのみを許可し、TLS 設定を定期的にテスト (SSL Labs 等)。
- パスワードリセットトークンは十分な長さ (128 bit+) と有効期限 (≤1h)。
- データベースでの静的暗号化 (TDE) や S3 バケット暗号化を検討。

## コードスニペット (Node.js)
```js
// Bcrypt でのハッシュ化
const bcrypt = require('bcryptjs');
const SALT_ROUNDS = 12;

async function hashPassword(password) {
  return await bcrypt.hash(password, SALT_ROUNDS);
}

async function verifyPassword(password, hash) {
  return await bcrypt.compare(password, hash);
}
```

## 参考資料
- OWASP Cheat Sheet: Cryptographic Storage
- Mozilla SSL Configuration Generator
- NIST SP 800-63B Digital Identity Guidelines
