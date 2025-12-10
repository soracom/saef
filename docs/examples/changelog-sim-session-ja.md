---
title: "SIMセッション履歴エクスポートの改善"
labels: Improvements
japanOnly: true
publishOn: 2025-02-03T11:00:00+09:00
isDraft: true
---

# 概要
SIM詳細画面から90日分のセッション履歴をCSVで直接取得できるようになりました。CREチームやお客様は、サポートへの依頼なしで遅延やAPN情報を分析できます。

## 詳細
- ユーザーコンソール（SIM管理 → SIM一覧 → 対象SIM → セッション履歴）に **CSVダウンロード** ボタンを追加。
- 画面上のフィルター（日付範囲、オペレーター、接続種別）をそのままCSVに反映。
- API `GET /subscribers/{imsi}/sessions/export` に `timezone_offset` パラメーターを追加し、Root/SAM権限に応じたオペレーター範囲のみ取得。

## 提供開始 / タイムライン
- 2025年2月3日（JST）より日本カバレッジで提供開始。
- 対象プラン：plan01s / planX3 / plan-D / plan-K2、仮想SIM（Arc）。

## ご利用方法 / 次のステップ
1. ユーザーコンソールで **SIM管理 → SIM一覧 → 対象SIM → セッション履歴** を開く。
2. 日付範囲や接続種別など必要なフィルターを設定。
3. **CSVダウンロード** をクリックしてファイルを保存。
4. API利用の場合は `GET /subscribers/{imsi}/sessions/export` を呼び出し、`timezone_offset` などのクエリを指定。
5. 詳細手順は `outputs/<slug>/docs/docs-ja.md` を参照してください。

## お問い合わせ
ご不明な点がございましたら、[SORACOM サポート](https://support.soracom.io/hc/ja/requests/new) までお問い合わせください。

