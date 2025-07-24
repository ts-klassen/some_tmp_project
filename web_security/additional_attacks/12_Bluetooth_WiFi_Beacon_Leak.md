# Bluetooth / Wi-Fi ビーコン情報漏えい

## 概要
Web Bluetooth API や（今後実装が進む）Web Wi-Fi API、Web NFC などを通じてブラウザが周辺デバイス情報を取得できるようになった。ユーザ承認が前提だが、誤って許可した場合やサードパーティスクリプトが挿入された場合に端末識別子・位置情報が漏えいするリスクがある。

## 攻撃シナリオ
1. 悪意サイトが `navigator.bluetooth.requestDevice()` を発行し、名称・MAC アドレスを取得。
2. 取得した識別子をハッシュして送信し、ユーザトラッキングや所在推定に利用。
3. 企業オフィス内でアクセスポイント一覧を収集し、ネットワーク構成を推測して後続攻撃の設計に活用。

## 影響
・ユーザ行動や位置情報の追跡につながるプライバシー侵害  
・企業ネットワーク機器情報の漏えい  
・IoT 機器への未承認接続・操作

## Web アプリ開発者が取れる対策
1. Permissions-Policy ヘッダで不要な API を明示的に無効化する。

   ```http
   Permissions-Policy: bluetooth=(), geolocation=(self)
   ```

2. サイトに Bluetooth 機能が不要なら `requestDevice()` などの呼び出しを実装しない。必要な場合は目的を UI で明示し、最小限のフィルタ（`filters` オプション）を設定する。
3. サードパーティスクリプトを読み込む場合は SRI + CSP で改ざんを防止し、必要最小限に限定する。
4. エンタープライズ環境では社内ポリシーで拡張機能・デバイス API の使用を制限し、機密エリアでのモバイルブラウジングを管理する。

## コード例（最小権限の Bluetooth 要求）
```js
const device = await navigator.bluetooth.requestDevice({
  filters: [{ services: ['battery_service'] }], // 必要なサービスだけを列挙
  optionalServices: []
});
```

## 参考文献
・W3C Web Bluetooth API  
・W3C Permissions Policy  
・OWASP Mobile Security Testing Guide  
