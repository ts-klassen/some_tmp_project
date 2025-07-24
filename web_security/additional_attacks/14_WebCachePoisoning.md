# Web Cache Poisoning / Cache Deception

## 概要
CDN やリバースプロキシのキャッシュキー設計が不適切な場合、攻撃者は改ざんレスポンスをキャッシュに保存し、多数のユーザへ配布できる。ヘッダ差分やクッキー、パス名の罠を利用する。

## 攻撃例
1. キャッシュキーにクエリパラメータが含まれない CDN に対し、`?callback=<script>` を付与して JSONP レスポンスを XSS 用に汚染。  
2. `/.well-known/` のような安全ディレクトリ名に `.html` を付けて静的ページとしてキャッシュさせ、被害者情報を含むレスポンスを汎用化。

## 影響
・大量ユーザへの Stored XSS, deface  
・キャッシュ経由で CSRF トークンや機密ヘッダが漏えい  
・一斉ログアウト／DoS

## 防御策
1. キャッシュキーに **ホスト、パス、クエリパラメータ、認証フラグ** を含める。  
2. 動的レスポンスには `Cache-Control: private, no-store` を明示。  
3. Vary ヘッダ (`Vary: Authorization, Cookie`) を適切にセット。  
4. ファイル拡張子で静的/動的を判定しない設計を徹底。  
5. セキュリティヘッダ (CSP, X-Content-Type-Options) で XSS 連鎖を防止。

## 参考
・James Kettle “Practical Web Cache Poisoning”  
・OWASP Caching Guide  
