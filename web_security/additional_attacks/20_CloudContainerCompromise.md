# Cloud / Container 侵害チェーン

## 概要
クラウドネイティブ環境では、コンテナエスケープ、Kubernetes 誤設定、IMDS (Instance Metadata Service) アクセスなどが連鎖し、ホスト OS やクラウドアカウント全体の侵害に繋がる。Web アプリからの SSRF が起点になるケースも多い。

## 攻撃例
1. **コンテナエスケープ**：runC/Cgroup 脆弱性を利用しホスト権限取得。  
2. **過剰権限の Kubernetes RBAC**：`system:masters` 権限を持つ ServiceAccount で API 全権限。  
3. **IMDSv1 SSRF**：メタデータ URL から AWS IAM トークンを盗み S3 全削除。  
4. **etcd 認証なしアクセス**：全クラスタシークレットを入手。

## 影響
・クラウドアカウント全体のリソース削除・マイニング  
・機密データ漏えい (DB パスワード、TLS キー)  
・横展開による他環境/リージョン侵害

## 防御策
1. PodSecurityPolicy / Pod Security Standards で `privileged` = false、ホストマウント禁止。  
2. NetworkPolicy / Calico で east-west トラフィックをマイクロセグメンテーション。  
3. IMDSv2, Azure IMDS HopLimit=1 を必須化し、SSRF をブロック。  
4. trivy, kube-bench で CIS Benchmark 遵守度を CI/CD ＆ CronJob でスキャン。  
5. IAM 最小特権、資源ポリシー条件 (aws:SourceVpce 等) で範囲限定。  
6. Audit Log / CloudTrail を有効化し、異常 API コールをリアルタイム検知。

## 参考
・Kubernetes Hardening Guidance (NSA/CISA)  
・CNCF Cloud Native Security Whitepaper  
