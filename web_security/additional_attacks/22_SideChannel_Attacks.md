# サイドチャネル攻撃（タイミング・キャッシュ）

## 概要
アルゴリズムの実行時間、キャッシュ状態、電力消費など副次的情報を観測し、秘密情報（暗号鍵、トークン）を推測する攻撃。Web アプリではタイミング差異が主に狙われる。

## 典型例
1. **タイミング攻撃 (Password / JWT)**：文字列比較が一致文字数で早期 return すると、バイト単位で推測可能。  
2. **Spectre / Meltdown 系**：CPU 投機実行の副作用を JS 経由の `Array` アクセス時間で計測し、カーネルメモリを読む。  
3. **Browser Cache Timing**：`link` プリフェッチ有無の差で閲覧履歴を推測。

## 影響
・パスワード、CSRF トークン、JWT 秘密鍵推定  
・機密メモリ漏えい、SandBox エスケープ

## 防御策
1. 比較には **constant-time アルゴリズム**（`crypto.timingSafeEqual` など）を使用。  
2. ハードウェアレベルで MDS, Spectre 対策パッチ適用、 WASM 共有バッファを無効化。  
3. キャッシュ状態でアクセス権判断をしない SameSite 設計。  
4. HSM/KMS に鍵を格納し、アプリには API 介してしか鍵が触れない構造に。

## コード例（Node.js）
```js
import crypto from 'crypto';

function secureCompare(a, b) {
  const bufA = Buffer.from(a);
  const bufB = Buffer.from(b);
  if (bufA.length !== bufB.length) return false;
  return crypto.timingSafeEqual(bufA, bufB);
}
```

## 参考
・NIST SP 800-90B 補遺  
・Google Project Zero Blog (Spectre)  
