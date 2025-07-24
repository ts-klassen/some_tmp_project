# 秘密情報の「影踏み」漏えい（Git History / CI Logs）

## 概要
API キーやパスワードを Git リポジトリに一度でもコミットすると、ファイルを削除しても履歴 (`git log`, `git reflog`) に残る。CI ログやキャッシュも含め多重にコピーされ、完全削除が難しい。

## 攻撃フロー
1. 開発者が `.env` を一時的にコミットし、PR で削除。  
2. しかし履歴やフォークには残存し、公開レポジトリなら GitHub Search で容易に発見。  
3. 攻撃者がキーを用いて API 呼び出し → クレジットカード課金・データ抽出。

## 影響
・クラウド課金の不正利用  
・ユーザデータ漏えい、バックエンドアクセス  
・キー失効までの間、攻撃範囲が無制限

## 防御策
1. **git-secrets / pre-commit hook** でコミット時にシークレット文字列をスキャン。  
2. 機密は環境変数 + Secret Manager (AWS, GCP) に格納し、コードベースに含めない。  
3. 誤コミット時は BFG Repo-Cleaner などで履歴を完全書き換え後、**必ず鍵をローテーション**。  
4. CI サービスのログに環境変数をエコーしない (`set +x`)。  
5. GitHub の “Secret scanning” や TruffleHog を有効にし、検出アラートを即時対応。

## 参考
・GitHub Advanced Security Secret Scanning  
・OWASP Credential Stuffing Prevention Cheat Sheet  
