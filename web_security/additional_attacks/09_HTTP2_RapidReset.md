# HTTP/2 Rapid Reset（DoS 攻撃）

## 概要
HTTP/2 プロトコルのストリームを大量に開いてすぐに `RST_STREAM` でキャンセルすることを高速で繰り返し、サーバの CPU・メモリを枯渇させるサービス拒否 (DoS) 攻撃。2023 年以降に報告が増加。

## 攻撃メカニズム
1. 攻撃者クライアントは 1 つの TCP コネクションで数万単位のストリームを生成。  
2. 直後に `RST_STREAM` フレームを送信し、サーバ側リソース確保 → 解放をループ。  
3. 並列コネクションやボットネットで同時多発し、サーバスレッド／メモリを枯渇させる。

## 影響
・Web/AP サーバの CPU 使用率が 100% となり応答不能  
・同居している他サービスにも影響  
・クラウドコスト高騰

## 防御策
1. サーバ/リバースプロキシを最新版へアップデート（nginx 1.23.4+, Apache 2.4.57+ 等）。  
2. HTTP/2 レイヤの Rate Limit を実装（ストリーム数・RST_STREAM 連打をしきい値で遮断）。  
3. CDN／WAF (Cloudflare, AWS Shield) の HTTP/2 flood 防御を有効化。  
4. 自動スケール＋アラートでリソース枯渇を早期検知。

## 参考
・Cloudflare Blog “HTTP/2 Rapid Reset” 攻撃分析  
・RFC 9113 Hypertext Transfer Protocol Version 2  
