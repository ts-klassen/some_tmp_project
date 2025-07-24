# DOM-based XSS（DOM XSS）

## 概要
サーバレスポンスにスクリプトは含まれないが、クライアント側 JavaScript が `location.search` や `document.cookie` などから取得したデータを安全でない方法で DOM に書き込み、XSS が発生するタイプ。

## 攻撃フロー
1. 攻撃者は `https://site.example/profile#<script>alert(1)</script>` のように悪意ペイロードを URL フラグメントに埋め込む。  
2. フロントコードが `location.hash` を読み取り `innerHTML` に挿入する。
3. スクリプトが実行され、Cookie 盗難や DOM 変更が行われる。

## 影響
・ユーザセッション乗っ取り  
・フィッシング画面生成  
・不正な API 呼び出し

## 防御策
1. DOM へ挿入する際は `textContent` や `setAttribute` など安全 API を利用し、`innerHTML` を避ける。  
2. 外部入力をサニタイズするライブラリ（DOMPurify など）を導入する。  
3. Content Security Policy (CSP) を `script-src 'self'` とし、`strict-dynamic` を併用する。  
4. ルーター (React Router など) を活用して URL パラメータを型検査し、不正文字列を拒否。

## コード例（React）
```jsx
import DOMPurify from 'dompurify';

export default function Comment({ raw }) {
  const sanitized = DOMPurify.sanitize(raw);
  return <div dangerouslySetInnerHTML={{ __html: sanitized }} />;
}
```

## 参考
・Google DOM XSS Wiki  
・OWASP XSS Prevention Cheat Sheet  
