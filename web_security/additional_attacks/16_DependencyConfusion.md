# 依存関係型サプライチェーン攻撃（Dependency Confusion / Typosquatting）

## 概要
内部レジストリ専用のパッケージ名と同名のパッケージを公開レジストリ (npm, PyPI 等) に公開し、ビルドシステムの解決優先度を逆手に取って悪意コードを注入する攻撃。似た綴り (lodashs など) を使う Typosquatting も同系統。

## 攻撃フロー
1. 攻撃者は `@company/ui-components` という社内専用パッケージ名を npm 公開リポジトリに登録。  
2. 社内 CI/CD が外部を先に解決し、悪意パッケージをインストール。  
3. ビルド時スクリプトや postinstall で機密環境変数や `.npmrc` を exfiltrate。  
4. 本番デプロイまで混入し、RCE やデータ漏えいが発生。

## 影響
・CI/CD レイヤでの機密変数漏えい  
・本番環境での任意コード実行  
・サプライチェーン全体への水平展開

## 防御策
1. **scoped registry** を強制 (`@company:*` は社内レジストリのみ解決) し、npmrc で外部 fallback を無効にする。  
2. パッケージ署名 (Sigstore, PGP) や provenance 記録 (SLSA) を導入し、検証。  
3. `npm config set strict-ssl true` などで中間者攻撃を防止。  
4. Dependabot, SCA ツールで未知のパッケージ検出時にレビューを必須とする。

## 参考
・Alex Birsan “Dependency Confusion” 研究  
・OWASP Supply Chain Threats  
