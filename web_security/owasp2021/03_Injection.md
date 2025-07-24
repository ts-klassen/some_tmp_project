# OWASP Top 10 2021 – A03 Injection

## 概要
信頼されていない入力を適切に検証・サニタイズせず、コマンドやクエリとして実行してしまう脆弱性。SQL/NoSQL、OS コマンド、LDAP、XPath など様々な形態が存在。

## 代表的な攻撃例
### 1. SQL Injection
`' OR 1=1 --` などを挿入して全レコードを取得、更新、削除。

### 2. OS コマンドインジェクション
`user && rm -rf /` のようなペイロードでサーバ上のコマンドを実行。

### 3. NoSQL Injection (MongoDB)
`{"$gt": ""}` を挿入し認証バイパス。

## 影響
- 機密データの流出
- データ破壊・不正操作
- サーバ乗っ取り、横展開

## セキュア設計 / 実装ガイド
1. **プリペアドステートメント / パラメタライズドクエリ** を徹底。
2. 動的に生成するクエリ・コマンドを最小化し、ホワイトリスト方式で入力を検証。
3. ORM やクエリビルダを利用し、エスケープを自動化。
4. 入力値をサーバ側で型・長さ・フォーマット検証し、ログにもサニタイズ済みの値のみ記録。

## フロントエンド開発者の観点
- クライアント側バリデーションは UX 目的であり、セキュリティ保証とは別物。
- GraphQL でも入力値長大化による DoS に注意。

## バックエンド開発者の観点
- Sequelize, Prisma など ORM のエスケープ機能を無効化しない。
- システムコマンド実行が必要な場合は child_process.exec ではなく spawn + 引数配列。
- DB アカウント権限を最小化 (読み取り専用など)。

## コードスニペット (Node.js + pg)
```js
// パラメタライズドクエリ
const { rows } = await db.query('SELECT * FROM users WHERE id = $1', [req.params.id]);
```

## 参考資料
- OWASP SQL Injection Prevention Cheat Sheet
- SQLMap – 自動 SQLi 診断ツール
- NCC Group NoSQL Security Cheat Sheet
