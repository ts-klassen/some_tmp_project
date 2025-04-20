# フィードバック（作問者向け）

演習全体として、とてもバランスの取れた 17 問でした。基礎から分析関数まで段階的に学べる構成で、学習者が「成功体験」を積みやすい良問だと思います。以下、実装してみて気付いた点を共有します。

## 良かったところ

* **難易度のグラデーションが明快** ‑ ★→★★→★★★ と少しずつ要求が上がるので取り組みやすいです。
* **サンプルデータが小さい** ため、実行計画を眺めてもノイズが少なく、初学者でも理解しやすいと感じました。
* `check.sh --detail` で失敗箇所をすぐ diff 確認できるのは非常に便利でした。

## 改善提案

1. ### Q04 の結果順序について
   期待 CSV は同一 `order_count` の場合に
   `Eve → Dave → Bob → Alice → Carol` の順になっていますが、
   これはサンプルデータに依存した並びで学習上の必然性が薄いように感じました。
   
   *提案*: `ORDER BY order_count DESC, user_id` のように自然キーで tie‑break させると実装がシンプルになり、「余計な CASE」を書かずに済みます。

2. ### Q14 の `CURRENT_DATE` 依存
   採点用の expected_results/14.csv が **2025‑03‑22 〜 2025‑04‑20** 固定のため、
   実行環境の日付が変わるとクエリを書き換えても常に fail になります。
   
   *提案*: `generate_series('2025‑03‑22'::date, '2025‑04‑20'::date, '1 day')` のように
   ベース日付をハードコードする or `init.sql` で `ALTER SYSTEM SET timezone` 等で
   テスト固定日を設定しておくと良いと思います。

3. ### Docker Compose プラグイン依存
   `check.sh` が `docker compose` コマンドを前提にしていますが、
   CI 環境では旧 `docker‑compose` バイナリしか入っていないことがあります。
   `docker compose` が無い場合に fallback する、あるいは Makefile 経由にするなど
   ラッパースクリプトで互換性を持たせるとより親切です。

4. ### CSV 行末の CRLF
   `expected_results/*.csv` が CRLF になっているファイルと LF のファイルが混在していました。
   Git の autocrlf 設定次第で diff が出てしまう可能性があるので、
   行末を統一しておくと安心です。

5. ### Q17 の NULL 並び順
   `ORDER BY product_id NULLS LAST, month NULLS LAST` だと
   `(NULL, NULL)` の総計がファイル末尾以外に来る可能性があります。
   `GROUPING` を使って `ORDER BY GROUPING(product_id), product_id` … のように書かせると、
   「小計→総計」の並びを明示的に学べて良いかもしれません。

---

以上、ご参考になれば幸いです。楽しい課題をありがとうございました！
