# OWASP Top 10 2021 – A05 Security Misconfiguration

## 概要
安全でないデフォルト設定、設定ミス、不要な機能の有効化などによって攻撃者に余計な攻撃面を提供してしまう問題。インフラ、アプリ、プラットフォーム問わず発生。

## 代表的なミス例
### 1. デフォルトパスワードの未変更
管理コンソールや DB の初期資格情報をそのまま運用。

### 2. 詳細スタックトレースの公開
`NODE_ENV=production` でない環境変数設定により、例外時に内部パスが漏えい。

### 3. 不要サービスの起動
開発用ポート (phpMyAdmin, Redis) をインターネットに晒す。

### 4. CORS ワイルドカード許可
`Access-Control-Allow-Origin: *` を本番環境で設定。

## 影響
- 未認証で管理画面に侵入
- 内部構成・IAM 情報漏えい
- 横移動やさらなる攻撃の踏み台

## セキュア設計 / 実装ガイド
1. 本番環境ビルド設定 (`NODE_ENV=production`, 厳格 CSP 等) を CI で自動適用。
2. 不要なポート・サービス・サンプルアプリを無効化/削除。
3. Infrastructure as Code (Terraform, Ansible) で設定をコード化し、レビュー対象にする。
4. CIS Benchmark, trivy, kube-bench などで定期スキャンを自動化。

## フロントエンド開発者の観点
- ビルド時にデバッグ用コンソールやソースマップを除外する。
- CSP, SRI, Referrer-Policy などセキュリティヘッダを設定 (Helmet 等)。

## バックエンド開発者の観点
- コンテナイメージは最小 (distroless など) を選択し、不要バイナリを排除。
- 環境変数 & シークレットのスコープを最小限に保つ。

## 参考資料
- OWASP Secure Headers Project
- CIS Benchmarks – Linux, Kubernetes
- Mozilla Observatory
