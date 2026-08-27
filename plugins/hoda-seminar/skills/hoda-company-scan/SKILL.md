---
name: hoda-company-scan
description: 保田研の企業分析の入口。日本の上場企業について「まず一通り見たい」「この会社を分析したい」「企業PJの対象企業を調べる」「輪読のケース企業の財務を押さえる」ときに使う。EDINET DBコネクタから財務時系列・セグメント・株主構成・ガバナンス・IR資料を一括で取得し、保田研の観点（企業価値向上×社会的価値向上）で初期スキャンを出す。ROICツリーやバリュエーションに進む前の土台づくり。
---

# 企業初期スキャン

対象企業を保田研の型で一通り押さえる。ここで得た土台の上に `hoda-value-driver-tree`、`hoda-peer-benchmark`、`hoda-valuation`、`hoda-cross-swot` を重ねる。

## 前提

- **EDINET DBコネクタ（MCP）が接続されていること**を最初に確認する。接続されていなければ、ユーザーに「設定 → コネクタ → EDINET DB」で接続してもらうよう伝える。
- 対象が日本の上場企業でない場合、EDINET DBは使えない。その旨を伝え、Web検索と一次資料（10-K、Annual Report）に切り替える。

## 手順

### 1. 目的を確認する

先に聞く。分析の深さがまるで変わる。

- 用途は何か（企業PJの提案先／輪読のケース／実証分析のサンプル／コンペ）
- 提案先・発表先は誰か（→ 決まっていれば `hoda-kimehen` を先に回す）
- 競合として並べたい会社はあるか（なければこちらで候補を出して確認を取る）

### 2. 企業を特定する

`search_companies` で社名または証券コードから EDINET コードを引く。同名・グループ会社があるので、**上場企業体（連結の親）を取っているか必ず確認する**。

### 3. コアデータを取る

以下をまとめて取得する。1回ずつ順に呼ばず、独立したものは並行して呼ぶ。

| 取得内容 | ツール | 見るポイント |
|---|---|---|
| 財務時系列（最大10年） | `get_financials` | 売上・営業利益・純利益・総資産・自己資本・営業CF・投資CF |
| 企業サマリと健全性 | `get_company` / `get_analysis` | 業界内での位置、強み弱みの当たり |
| セグメント別業績 | `get_segments` | どの事業が稼いでいるか。全社ROICを分解する起点 |
| 販管費内訳 | `get_detailed_expenses` | 人件費・R&D・広告宣伝。人的資本経営の議論で効く |
| 直近決算 | `get_earnings` | 足元のモメンタムと会社計画 |

### 4. 非財務・ガバナンスを取る

保田研のテーマ（ESG・人的資本経営）はここに出る。**財務だけ見て終わりにしない。**

| 取得内容 | ツール |
|---|---|
| 有報の定性テキスト（事業等のリスク、MD&A、サステナビリティ） | `get_text_blocks_structured` |
| 役員一覧・役員報酬・報酬決定方針 | `get_directors` / `get_director_compensation` / `get_compensation_text` |
| 大株主・株主構成 | `get_shareholders` / `get_shareholder_categories` |
| 政策保有株式 | `get_cross_shareholdings` |
| 統合報告書・中計などのIR資料 | `get_ir_documents` / `get_ir_pdf_url` |
| 中計KPIのコミット vs 実績 | `get_kg_kpi_track_record` |
| アクティビスト・TOB・MBO等のイベント | `get_events` / `get_activist_positions` |

### 5. アウトプットを組む

`references/scan-output.md` の型に沿ってまとめる。

10年分のトレンドは必ず**折れ線グラフ**にする（`hoda-peer-benchmark` のチャート規約に従う）。表だけで済ませない。

### 6. 次に進む先を提示する

スキャンの結果から、次にどの分析が効くかを1〜2個だけ挙げる。全部やろうとしない。

- 収益性の分解が要る → `hoda-value-driver-tree`
- 競合との相対評価が要る → `hoda-peer-benchmark`
- 株価が妥当かを問う → `hoda-valuation`
- 打ち手に落とす → `hoda-cross-swot`

## やってはいけないこと

- 数字を出所なしで書く。EDINET DBから取った値は「出所：有価証券報告書（EDINET）、FY20XX」と明示する。
- 会社側の開示表現をそのまま結論にする。統合報告書の「弊社の強み」は仮説であって事実ではない。**KPIのコミット vs 実績（`get_kg_kpi_track_record`）で裏を取る。**
- ESGを「やっているかどうか」で評価する。保田研で問うのは、それが企業価値にどう効いているか。
