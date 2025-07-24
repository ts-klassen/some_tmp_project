# WebAssembly / ブラウザ内 RCE

## 概要
WebAssembly (WASM) はブラウザで高性能コードを実行可能にするが、WASM モジュールに脆弱ロジックまたは悪意コードが含まれると、Same-Origin 制限を迂回し内部 API への大量リクエストやメモリ破壊を試みるケースがある。

## 攻撃シナリオ
1. 攻撃者が提供する WASM モジュールを `import` したウェブアプリが署名や整合性を検証しない。  
2. WASM 内から `fetch` や WebGL API を濫用し、大量リクエストを内部ネットワークへ送信。  
3. 型安全性チェックを回避する脆弱性がブラウザに存在する場合、ネイティブ RCE に連鎖する。

## 影響
・内部 API への SSRF・DoS  
・ブラウザサンドボックスを脱出するゼロデイに繋がる  
・サプライチェーン型マルウェア配布

## 防御策
1. WASM を外部ホストから読み込む場合、**Subresource Integrity (SRI)** ハッシュを必ず付与。  
2. CSP に `script-src 'self'` と `wasm-unsafe-eval` を禁止し、動的ロードを抑止。  
3. WASM モジュールにもコード署名（Sigstore WASM Sign）の導入を検討。  
4. 依存する WASM のレビューと自動スキャン (wasm-security, vivisect) を CI へ組み込む。

## 参考
・Mozilla Secure WASM Guidelines  
・Google Project Zero WASM Exploitation Research  
