# OWASP Top 10 2021 – A01 Broken Access Control

## 概要
アクセス制御（権限/ロール管理）が不十分で、ユーザが本来許可されていないリソースや操作に到達できてしまう問題。

## 代表的な攻撃例
### 1. IDOR (Insecure Direct Object Reference)
リソース ID を推測・書き換えて他ユーザのデータを取得 / 変更。

### 2. 管理機能への直接アクセス
UI で隠された /admin エンドポイントを URL 直打ちして権限昇格。

### 3. 不正なメソッド操作
`GET /orders/10` は許可でも、同じ ID で `DELETE /orders/10` が許可されてしまう。

## 影響
- 個人情報・機密情報の漏えい
- 不正なデータ改ざん・削除
- サービス停止（DoS）や信頼失墜

## セキュア設計 / 実装ガイド
1. サーバ側で必ず認可チェック (RBAC / ABAC) を行う。
2. ビジネスロジックと認可ロジックを分離し、共通ミドルウェア化。
3. リソース ID は推測困難な UUID などを採用。
4. 権限マトリクスを設計段階で作り、単体/統合テストに落とし込む。

## フロントエンド開発者の観点
- UI 側だけで「見せない」制御に頼らない。
- SPA ルーティングに beforeEach ガードを入れる場合でも、最終判断は API へ委譲する。

## バックエンド開発者の観点
- 各 API に認可ミドルウェアを必須化。
- ドメインモデル単位で `ownerId === authUser.id` などの検証を徹底。
- エラーメッセージは統一し、存在可否が推測できないようにする。

## コードスニペット (Node.js/Express)
```js
// 認可ミドルウェアの例
function requireRole(role) {
  return (req, res, next) => {
    if (!req.user || req.user.role !== role) return res.sendStatus(403);
    next();
  };
}

app.delete('/users/:id', auth, requireRole('admin'), async (req, res) => {
  await User.delete(req.params.id);
  res.sendStatus(204);
});
```

## 参考資料
- OWASP Cheat Sheet: Authorization
- OWASP Testing Guide: Access Control Testing
- IPA「安全なウェブサイトの作り方」第 5 章
