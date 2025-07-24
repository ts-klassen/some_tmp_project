# サブドメインテイクオーバー (Subdomain Takeover)

## 概要
DNS に残存する CNAME / A レコードが指すホスティング先 (S3, GitHub Pages, Azure FrontDoor など) が未使用の場合、攻撃者はそのサービス上で同名リソースを作成し、正規ドメイン配下で任意コンテンツをホスティングできる。フィッシングやマルウェア配布に利用される。

## 攻撃手順の例
1. `corp.example.com` が GitHub Pages を向く CNAME として設定されているが、リポジトリが削除されている。  
2. 攻撃者が同名の GitHub アカウント/リポジトリを作成し Pages を有効化。  
3. 既存 DNS レコードにより、`corp.example.com` は攻撃者コンテンツを配信。  
4. メールや SEO を駆使してフィッシングサイトとして悪用。

## 影響
・ブランドドメインでのフィッシング・マルウェア配布  
・SPF/DKIM を回避したメール送信  
・Cookie／LocalStorage スコープによるセッション乗っ取り

## 防御策
1. **DNS 自動棚卸し**：IaC (Terraform) と照合し、不要レコードを検出・削除。  
2. ホスティング停止時は DNS を即座に削除、または `null MX` レコードなどに置換。  
3. CAA レコードで証明書発行先を限定し、不正 TLS 証明書取得を阻止。  
4. 外部モニタリング (Can I Take Over XYZ, SecurityTrails) を導入し継続監視。

## 参考
・canitakeover.com プロジェクト  
・OWASP Subdomain Takeover Prevention Cheat Sheet  
