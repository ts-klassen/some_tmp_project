# HTTP Header Injection / CRLF Injection

## 概要
レスポンスヘッダにユーザ入力をそのまま含めると、キャリッジリターン (CR) とラインフィード (LF) の組み合わせ「CRLF」によってヘッダ境界を破壊し、追加ヘッダやレスポンスボディを注入できる。キャッシュポイズニングや任意 Cookie 設定につながる。

## 攻撃例
1. アプリが `Location: /search?q={keyword}` を出力する際、攻撃者が `%0d%0aSet-Cookie: admin=true` を挿入。  
2. レスポンスヘッダが分断され、以降のユーザに偽 Cookie が配布される。

## 影響
・キャッシュポイズニングにより大多数のユーザへ悪意レスポンスを配布  
・Cookie 強制設定で権限昇格やセッション乗っ取り  
・ブラウザやプロキシのレスポンス解釈エラー

## 防御策
1. ヘッダ値に改行や制御文字を一切許容しない。入力をホワイトリスト検証し、`encodeURIComponent` などでエンコードする。  
2. フレームワークの安全 API (`res.setHeader`) を利用し、文字列連結で直接ヘッダを生成しない。  
3. リダイレクト先など動的ヘッダの値はドメインやパスを固定する。

## コード例（Express）
```js
app.get('/redirect', (req, res) => {
  const target = req.query.target || '/';
  if (/[\r\n]/.test(target)) return res.status(400).send('invalid');
  res.setHeader('Location', encodeURI(target));
  res.status(302).end();
});
```

## 参考
・PortSwigger CRLF Injection  
・OWASP HTTP Response Splitting  
