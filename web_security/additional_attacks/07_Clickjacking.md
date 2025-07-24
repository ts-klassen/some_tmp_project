# Clickjacking（UI Redress Attack）

## 概要
透明またはスタイルを改変した iframe の中に正規サイトを埋め込み、ユーザが見えている UI と異なる場所をクリックさせる攻撃。意図せず「購入」「いいね」などを実行させられる。

## 攻撃例
1. 攻撃者サイトが全画面の `iframe src="https://bank.example/transfer"` を透明にして配置。  
2. 上に偽の「クリックして動画再生」ボタンを描画。  
3. ユーザがボタンを押すと iframe 内の送金ボタンが押下される。

## 影響
・不正送金、SNS の不正「いいね」、設定変更  
・広告クリック詐欺、CAPTCHA 迂回

## 防御策
1. `X-Frame-Options: DENY` または `SAMEORIGIN` をレスポンスに設定し、iframe 埋め込みを拒否または制限する。  
2. `Content-Security-Policy: frame-ancestors 'none'` を併用すると最新ブラウザにも適用できる。  
3. クリック位置の座標検証やダブルクリック確認など UI 側の防御を追加する。  
4. 重要操作には再認証や CSRF トークン入力を要求する。

## コード例（Express + Helmet）
```js
import helmet from 'helmet';
app.use(helmet.frameguard({ action: 'deny' }));
```

## 参考
・OWASP Clickjacking Defense Cheat Sheet  
