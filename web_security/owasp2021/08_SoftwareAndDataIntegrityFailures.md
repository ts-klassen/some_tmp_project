# OWASP Top 10 2021 – A08 Software and Data Integrity Failures

## 概要
コード、コンフィグ、データの整合性を検証しない／保護しないことで、サプライチェーン攻撃や改ざんされたアップデートが成立してしまう問題。

## 代表的なシナリオ
### 1. CI/CD での不正スクリプト注入
ビルドフェーズで外部スクリプトを curl | bash し、マルウェアを仕込まれる。

### 2. 署名されていないソフトウェアアップデート
攻撃者が更新サーバを偽装し、悪意あるバイナリを配布。

### 3. デシリアライズ脆弱性
改ざんされたオブジェクトを読み込み、RCE に至る。

## 影響
- リモートコード実行
- サプライチェーン全体への影響拡大
- 信頼失墜・法的責任

## セキュア設計 / 実装ガイド
1. Supply-chain Levels for Software Artifacts (**SLSA**) に沿った検証可能なビルド。
2. SBOM を生成し、アップデート時に差分検証。
3. IaC, コンテナイメージ, バイナリに **署名 (Cosign, Sigstore)** を付与。
4. デシリアライズは JSON 等の安全フォーマットを使用。

## フロントエンド開発者の観点
- CDN から読み込む JS/CSS には **Subresource Integrity (SRI)** を付与。
- Service Worker 更新時に署名/整合性チェック。

## バックエンド開発者の観点
- CI/CD パイプラインは原則コードベースに定義し、approve 付きで実行。
- 依存する Docker ベースイメージを digest ピン留め。

## 参考資料
- OWASP Dependency Track
- CNCF Supply Chain Security Whitepaper
- Google SLSA Framework
