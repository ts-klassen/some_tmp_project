# OWASP Top 10 2021 – A06 Vulnerable and Outdated Components

## 概要
既知の脆弱性を含む OSS ライブラリ、フレームワーク、OS、Docker イメージなどを使用し続けることで、攻撃者に侵入口を提供してしまう問題。

## 代表的なシナリオ
### 1. npm/yarn の依存脆弱性
古い `lodash` で Prototype Pollution が可能。

### 2. 古い Spring Framework
`Spring4Shell` のような RCE 脆弱性を含む。

### 3. 未パッチの OS パッケージ
`sudo` のバッファオーバーフローを突かれコンテナ脱出。

## 影響
- リモートコード実行 (RCE)
- 機密データ漏えい
- サプライチェーン攻撃の足掛かり

## セキュア設計 / 実装ガイド
1. **SBOM** (Software Bill of Materials) を生成し、依存関係を可視化。
2. Dependabot, Renovate などで自動アップデート PR を運用。
3. `npm audit`, `yarn npm audit`, `trivy fs` を CI で定期スキャン。
4. 不要な依存・transitive dep を定期的に棚卸し。

## フロントエンド開発者の観点
- `npm outdated` をスプリントごとに確認。
- Webpack/Babel の plugin も脆弱性対象になることを意識。

## バックエンド開発者の観点
- ベースイメージに tag:latest を使わず digest pinning。
- OS パッケージアップデートをイメージビルド時に実施 (`apk add --no-cache --upgrade`).

## 参考資料
- OWASP Dependency-Check
- GitHub Advisory Database
- CNCF Sigstore / Cosign (サプライチェーン署名)
