# ブラウザ拡張機能の悪用

## 概要
ブラウザ拡張機能 (Extension) は高い権限で DOM 操作や Cookie 取得、任意リクエストを行える。悪意ある拡張や乗っ取られた拡張がユーザセッションや機密情報を盗むケースが増加。

## 攻撃例
1. 人気拡張の開発者アカウントが買収され、更新版にデータ送信コードを追加。  
2. 被害サイトの DOM から CSRF トークンや JWT を抽出し外部サーバへ送信。  
3. WebRequest API を用いて任意ヘッダを追加し、CORS 制限をバイパス。

## 影響
・アカウント乗っ取り、機密情報漏えい  
・フィッシング誘導、広告挿入  
・サプライチェーンとして組織全体へ波及

## 防御策
1. 社内端末は拡張機能の **allowlist 制** を導入し、Chrome Enterprise Policy 等で強制。  
2. 重要業務は専用ブラウザプロファイル/コンテナを使用し、拡張をインストールしない。  
3. 権限が広い拡張（全サイトの DOM 参照など）はインストール前にレビューする。  
4. サイト側は `Content-Security-Policy` と `Subresource Integrity` で動的スクリプト挿入を制限。

## 参考
・Google Chrome Extensions Security Best Practices  
・Mozilla AMO Extension Guidelines  
