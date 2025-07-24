# Directory Traversal / Path Traversal

## 概要
`../` などの特殊文字列をパスに挿入し、想定外のファイルやディレクトリにアクセスする攻撃。機密ファイルの読み取り、設定ファイル入手、RCE へ発展する恐れがある。

## 典型的な例
1. ファイルダウンロード機能 `/download?file=report.pdf` に対し、`../../../../etc/passwd` を指定してシステムファイルを取得。
2. Web サーバにアップロードした悪性スクリプトを実行パスに移動させ RCE。

## 影響
・機密ファイル漏えい（/etc/passwd, .env など）  
・アプリケーションソースコードの露出  
・ファイル上書きによる任意コード実行

## 防御策
1. ユーザ入力をファイル名に直接使用しない。ID → サーバ側マッピングテーブルを利用する。  
2. パス正規化のうえ「許可ディレクトリの外かどうか」を `path.resolve()` で判定する。  
3. OS ユーザ権限を最小化し、読み取り専用ディレクトリに chroot / container で隔離する。  
4. ファイルのアップロード・ダウンロード API は MIME タイプや拡張子をホワイトリスト検証する。

## コード例（Node.js）
```js
import path from 'path';
const BASE = path.join(process.cwd(), 'reports');

app.get('/download', (req, res) => {
  const filename = req.query.file;
  const safePath = path.normalize(filename).replace(/^\.+/, '');
  const full = path.join(BASE, safePath);
  if (!full.startsWith(BASE)) return res.status(400).send('invalid');
  res.sendFile(full);
});
```

## 参考
・OWASP Path Traversal Cheat Sheet  
・CWE-22 Improper Limitation of a Pathname to a Restricted Directory  
