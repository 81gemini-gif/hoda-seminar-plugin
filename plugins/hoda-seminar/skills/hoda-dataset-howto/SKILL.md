---
name: hoda-dataset-howto
description: 実証分析用のデータセットの集め方と作り方。「データはどこから取ればいい」「財務データを一括で落としたい」「株価データが欲しい」「ESGスコアはどこにある」「データを結合したい」「パネルデータの作り方」といった質問で使う。保田研が使えるデータソース（大学契約DB＋無料ソース）と、企業コードの名寄せなど実務的な落とし穴をまとめてある。
---

# データセットの集め方

## 1. まず決めること

データを探し始める前に、これを紙に書く。**ここが曖昧なまま探すと必ず無駄になる。**

| 項目 | 決めること |
|---|---|
| **母集団** | 東証プライム全社か、特定業種か、TOPIX500か。**上場廃止企業を含めるか**（含めないと生存バイアスが入る） |
| **期間** | 何年から何年まで。**最低5年、実証なら10年以上**あると望ましい |
| **観測単位** | 1行＝1企業×1年（年次パネル）か、1企業×1四半期か、1イベントか |
| **必要変数** | Y、X、コントロール変数を全部リストアップする |
| **キー** | 何で企業を識別するか（証券コード、EDINETコード、法人番号） |

---

## 2. 使えるデータソース

### 大学契約DB（保田研が使えるもの）

| ソース | 得意なもの | 注意 |
|---|---|---|
| **日経NEEDS / 日経バリューサーチ** | 日本企業の財務データ、記事、業界情報。**一括ダウンロードに最も向く** | 利用規約上、再配布不可。学外への持ち出しに注意 |
| **Bloomberg** | 株価、マルチプル、コンセンサス予想、債券、ESGスコア。**時系列の一括取得が強い** | 端末が限られる。Excelアドインで落とすのが実務的 |
| **Refinitiv（旧Thomson Reuters）** | 株価、ESG（旧ASSET4）スコア、M&Aデータ | ESGスコアは実証分析でよく使われる |
| **SPEEDA** | 業界レポート、財務、企業一覧。**業界の全体像を掴むのに速い** | 実証用の大量データ取得には向きにくい |
| **Capital IQ** | グローバル財務、コンプス、取引事例 | 海外企業を含む比較に強い |
| **Astramanager** | 財務データ・スクリーニング | |

**使う前に、必ず利用規約と学外持ち出しの可否を確認する。**論文・発表で使う場合の出所表記も規約に従う。

### 無料で使えるもの

| ソース | 取れるもの | URL |
|---|---|---|
| **EDINET DBコネクタ（MCP）** | 有報ベースの財務時系列（最大10年）、セグメント、販管費内訳、株主、政策保有株、役員報酬、有報テキスト、統合報告書、中計KPI | このプラグインから直接呼べる。**まずここを試す** |
| **EDINET** | 有価証券報告書、大量保有報告書のXBRL/PDF原本 | disclosure2.edinet-fsa.go.jp |
| **TDnet** | 適時開示、決算短信 | 東証 |
| **e-Stat** | 政府統計（法人企業統計、経済センサス） | e-stat.go.jp |
| **国税庁法人番号公表サイト** | 法人番号（未上場含む） | EDINET DBの `search_corporate_master` から引ける |
| **JPX** | 上場企業一覧、市場区分、指数構成 | jpx.co.jp |
| **各社IRページ** | 統合報告書、中計、決算説明会資料 | |

---

## 3. 変数別・どこから取るか

| 変数 | 推奨ソース |
|---|---|
| 財務諸表項目（売上、営業利益、総資産、自己資本、有利子負債） | EDINET DB `get_financials` ／ 日経NEEDS |
| セグメント別業績 | EDINET DB `get_segments` |
| 販管費の内訳（人件費、R&D、広告宣伝） | EDINET DB `get_detailed_expenses` |
| 株価（日次・月次）、時価総額 | Bloomberg / Refinitiv / 日経 |
| 株主構成、外国人持株比率 | EDINET DB `get_shareholder_categories` `get_shareholders` |
| 政策保有株式 | EDINET DB `get_cross_shareholdings` |
| 取締役会構成、社外比率 | EDINET DB `get_directors` ／ コーポレート・ガバナンス報告書 |
| 役員報酬 | EDINET DB `get_director_compensation` `get_compensation_text` |
| ESGスコア | Refinitiv / Bloomberg / FTSE / MSCI |
| 人的資本指標（従業員数、平均年収、勤続年数、女性管理職比率） | 有報の従業員の状況。EDINET DB `get_text_blocks_structured` |
| 中計KPIのコミットと実績 | EDINET DB `get_kg_kpi_track_record` |
| M&A・TOB・アクティビストイベント | EDINET DB `get_events` `get_activist_positions` ／ Capital IQ |
| 不祥事・適時開示イベント | TDnet ／ 日経記事検索 |

---

## 4. 落とし穴（ここで必ず詰まる）

### 企業コードの名寄せ

**最大の詰まりどころ。**

- **証券コードは4桁と5桁が混在する。**2024年以降の新規上場に英字を含む5桁コードがある。文字列として扱う。数値にすると先頭の0が消える
- **EDINETコード（E00000形式）と証券コードは1対1ではない。**持株会社化、上場廃止、合併で変わる
- **社名は変わる。**社名で結合しない。必ずコードで結合する
- 対処：**マスタテーブルを1つ作る。**証券コード／EDINETコード／法人番号／社名／期間 の対応表を先に作り、全データをそれに寄せる

### 決算期のズレ

- 3月決算と12月決算が混在する。**「FY2024」が何月から何月かを定義して統一する**
- 決算期変更をした企業は、その年だけ変則決算（9ヶ月など）になる。年換算するか、その年を落とす

### 会計基準の混在

- 日本基準／IFRS／米国基準が混在する。**営業利益の定義が違う**
- IFRS採用企業は「営業利益」の中身が日本基準と異なる。EBITでそろえるか、基準ダミーを入れる

### 生存バイアス

- 「現在上場している企業」だけで過去10年を分析すると、**倒産・上場廃止した企業が落ちる**ため結果が良く出る
- 対処：各年時点の上場企業一覧を使う。難しければ、限界として明記する

### 単位

- 千円／百万円／円が混在する。**取り込んだ直後に百万円に統一する**
- 比率が%表記と小数表記で混在する

### 欠損

- 欠損を0で埋めない。**0と「データがない」は違う**
- 欠損が多い変数は使わない判断も必要

---

## 5. データセットを組む手順（R）

```r
library(tidyverse)

# 1. マスタ（企業コード対応表）を作る
master <- read_csv("company_master.csv") %>%
  mutate(sec_code = as.character(sec_code))   # 必ず文字列

# 2. 各ソースを読み込んでキーを揃える
fin <- read_csv("financials.csv") %>%
  mutate(sec_code = as.character(sec_code),
         fy = as.integer(fy))

gov <- read_csv("governance.csv") %>%
  mutate(sec_code = as.character(sec_code),
         fy = as.integer(fy))

# 3. 結合する（left_join で、落ちた件数を必ず確認する）
df <- master %>%
  left_join(fin, by = c("sec_code", "fy")) %>%
  left_join(gov, by = c("sec_code", "fy"))

cat("結合前:", nrow(master), "→ 結合後:", nrow(df), "\n")
df %>% summarise(across(everything(), ~sum(is.na(.)))) %>% glimpse()  # 欠損数

# 4. 単位を統一（百万円）
df <- df %>% mutate(across(c(sales, op_income, assets), ~ . / 1e6))

# 5. 派生変数を作る
df <- df %>%
  mutate(
    log_assets   = log(assets),
    leverage     = debt / assets,
    roic         = nopat / invested_capital,
    outside_ratio = outside_directors / total_directors
  )

# 6. ウィンザライズ（上下1%）
winsorize <- function(x, p = 0.01) {
  q <- quantile(x, c(p, 1 - p), na.rm = TRUE)
  pmin(pmax(x, q[1]), q[2])
}
df <- df %>% mutate(across(c(roic, leverage), winsorize))

# 7. 保存
write_csv(df, "panel_final.csv")
```

**結合のたびに件数を確認する。**黙って行が消えるのが一番怖い。

---

## 6. 再現できる形で残す

保田研は人が入れ替わる。**次の学期の人が同じ結果を出せる状態で残す。**

- [ ] 生データ（触っていないもの）を `raw/` に分けて保存し、**絶対に上書きしない**
- [ ] 加工は全部スクリプト（.R / .py）で行い、手作業でExcelをいじらない
- [ ] スクリプトに、**どこから取ったデータか**をコメントで書く
- [ ] 変数の定義書（変数名／意味／出所／単位）を1枚作る
- [ ] Driveのチームフォルダに `raw/` `script/` `output/` の構成で置く
- [ ] **個人アカウント依存のパスを書かない**

---

## 7. 個人情報・機密の扱い

- 大学契約DBのデータは**再配布不可**。他大学（合ゼミ）や企業に生データを渡さない
- 企業から直接もらった非公開データは、**開示可否を先方と先生に必ず確認する**
- ゼミ生の名簿（学籍番号、メールアドレス）を分析用データと同じフォルダに置かない
