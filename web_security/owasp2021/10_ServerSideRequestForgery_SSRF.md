# OWASP Top 10 2021 – A10 Server-Side Request Forgery (SSRF)

## 概要
攻撃者がサーバにリクエスト先を指定し、内部ネットワークやメタデータサービスへのリクエストを強制させる脆弱性。安全なはずのサーバ側からのリクエストが悪用される。

## 代表的な攻撃例
### 1. AWS メタデータサービスの窃取
`http://169.254.169.254/latest/meta-data/iam/security-credentials/` へアクセスし、IAM 認証情報を取得。

### 2. 内部管理コンソールのスキャン
`http://127.0.0.1:9000/admin` を叩き、未認証のまま操作。

### 3. DNS rebinding を伴う SSRF
一見外部ホストに見えるが、解決後ローカル IP に向かわせる。

## 影響
- クラウド認証情報の漏えい
- 内部システムのポートスキャン / 攻撃
- RCE や lateral movement への足掛かり

## セキュア設計 / 実装ガイド
1. 外部 URL を受け取る API では **プロトコル・ホスト・ポート allowlist** を実装。
2. SSRF-safe なライブラリ (eg. `safecurl`) やネットワーク egress 制御 (egress firewall) を組み合わせる。
3. クラウド環境で IMDSv2 (AWS) など防御機能を有効化。
4. レスポンスを外部へそのまま返さず、必要最小限の属性に変換。

## フロントエンド開発者の観点
- 画像プロキシなど「URL を渡してサーバ側取得」する設計時に SSRF を想定。

## バックエンド開発者の観点
- `http://localhost` や 0.0.0.0/8, 169.254.0.0/16 へのアクセスをブロック。
- URL パース後に DNS 再解決し、IP ベースでブロック判定。

## コードスニペット (Node.js SSRF ガード)
```js
import { parse } from 'url';
import dns from 'dns/promises';

async function isPrivate(hostname) {
  const { address } = await dns.lookup(hostname);
  return address.startsWith('10.') || address.startsWith('172.16.') || address.startsWith('192.168.');
}

app.post('/fetch', async (req, res) => {
  const { url } = req.body;
  const { hostname } = parse(url);
  if (await isPrivate(hostname)) return res.status(400).send('blocked');
  const data = await fetch(url).then(r => r.text());
  res.send(data);
});
```

## 参考資料
- Google Cloud: Mitigating SSRF in GCP
- AWS IMDSv2 Docs
- PortSwigger SSRF Cheat Sheet
