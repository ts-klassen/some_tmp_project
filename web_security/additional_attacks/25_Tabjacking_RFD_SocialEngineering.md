# クライアント系ソーシャルエンジニアリング攻撃

## 概要
ユーザ操作やブラウザ UI の盲点を突いて、悪意サイトへ遷移させたりマルウェアファイルを実行させる攻撃。Clickjacking に加え、Tabjacking や Reflected File Download (RFD) などが含まれる。

## 攻撃手法
### 1. Tabjacking
1. `window.open()` で正規ドメインのタブを開き、`target="_blank"` で外部リンクを開く。  
2. 直後に `window.opener.location` を書き換えてフィッシングページに差し替え。  
3. ユーザは URL バーを確認せず操作し、資格情報を入力。  
対策：`rel="noopener noreferrer"` を必ず付与し、`window.opener` 参照不可とする。

### 2. Reflected File Download (RFD)
1. 反射型 XSS に近いが、レスポンスを **`text/plain`** でダウンロードさせ、拡張子を `.bat` 等にして実行を誘導。  
2. ブラウザはファイルとして保存し、ユーザが実行すると OS コマンドが動く。  
対策：`Content-Disposition` で固定ファイル名、`X-Content-Type-Options: nosniff`、入力値をファイル名に含めない。

### 3. ソーシャルエンジニアリング強化
・スクリーンオーバーレイ、CAPTCHA 風 UI でクリック促誘導  
・QR フィッシング (Quishing)  
・Browser-in-the-Browser (BitB) 攻撃

## 影響
・フィッシング成功率向上  
・マルウェア実行によるエンドポイント侵害  
・ブランド信頼低下

## 共通防御策
1. 外部リンクは `rel="noopener noreferrer"` とし、`target="_blank"` 乱用を避ける。  
2. HTTP レスポンスヘッダで MIME Sniffing を防ぎ、ダウンロード時の拡張子を固定。  
3. ユーザ教育：ダウンロード警告、URL 確認、署名付き実行ファイルのみ許可。  
4. ブラウザ CSP (frame-ancestors, sandbox) を併用し、悪意コンテンツの埋め込みを抑止。

## 参考
・OWASP RFD Testing Guide  
・Google Security Blog on rel="noopener"  
