# ファイルアップロードを悪用した高度攻撃

## 概要
シンプルな拡張子チェックだけでは、不正スクリプトを画像や PDF、機械学習モデルに埋め込む「Polyglot ファイル」などを防げない。サーバサイドでの安全検証を怠ると RCE やマルウェア配布に繋がる。

## 攻撃手法
1. **Polyglot (PNG+PHP)**：PNG ヘッダ＋ペイロード末尾に `<?php ... ?>` を埋め込み、Apache の拡張子マッピングで実行。  
2. **Steganography Malware**：画像のピクセルデータに悪性コードを隠し、バックエンド ML サービスで実行。  
3. **Deep Learning Model 換装**：ONNX/TensorFlow SavedModel の重みを書き換え、推論時に任意 OS コマンドを実行。  
4. **Huge File DoS**：ギガバイト級ファイルをアップしてストレージ枯渇。

## 影響
・サーバ側 RCE、ランサムウェア  
・XSS / HTML Injection (user-content 配信)  
・ストレージ課金爆増、可用性低下

## 防御策
1. MIME タイプを **Magic Bytes** で検証し、信頼できない拡張子は拒否。  
2. 画像はサーバ側で再エンコード (ImageMagick `convert`) し、メタデータを剥ぎ取る。  
3. アップロード後にセキュリティスキャナ (ClamAV, yara) を走らせ、ML モデルは専用サンドボックスで検証。  
4. アップロード先を **別オリジン** (CDN) に置き、`Content-Type: application/octet-stream` 固定で XSS を防止。  
5. サイズ・拡張子・MIME 3 点で許可リストを定義し、CI に Media Security Scanner を組み込む。

## 参考
・OWASP Unrestricted File Upload Cheat Sheet  
・MITRE ATLAS ML Model Attack Taxonomy  
