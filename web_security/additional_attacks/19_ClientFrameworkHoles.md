# クライアントサイド・フレームワーク特有の脆弱性

## 概要
React, Angular, Vue などモダンフロントエンドフレームワークは XSS 防止機能を持つが、特定 API や設定ミスでバイパスが可能。Prototype Pollution やテンプレートインジェクションなど固有の攻撃ベクトルも存在する。

## 主な脆弱パターン
1. **Prototype Pollution (lodash.merge, `__proto__`)**：オブジェクト挿入で `toString` 上書き → 任意コード実行。  
2. **Angular Expression Injection**：`{{::constructor.constructor('alert(1)')()}}` など。  
3. **Vue JSX / v-html**：ユーザ入力をそのまま挿入し XSS。  
4. **React dangerouslySetInnerHTML**：サニタイズ不足で DOM XSS。

## 影響
・クライアント側 XSS によるセッション窃取  
・アプリケーションロジック改ざん  
・Supply Chain を介した広範囲なマルウェア拡散

## 防御策
1. フレームワークの **安全 API のみ** を使用し、バニラ DOM 操作 (`innerHTML`) を避ける。  
2. 依存パッケージを SCA (npm audit, Snyk) で常時スキャンし、Prototype Pollution CVE を即時パッチ。  
3. コンポーネント境界で `propTypes` / TypeScript による入力型制約を設ける。  
4. CSP を厳格に設定し、`unsafe-inline` を排除。  
5. ユニットテストでテンプレートインジェクションペイロードを自動挿入し回帰テスト。

## 参考
・OWASP Front-End Security Cheat Sheet  
・PortSwigger Polyglot Payload List  
