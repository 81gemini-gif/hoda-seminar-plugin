# 授業運営部が作るシートのテンプレ

保田研で実際に使われている2つのシートの構造と、テンプレを生成する手順。

**実データ（ゼミ生の氏名、提出物の中身）はここには含まれていない。**生成時は最新の名簿と提出物リストから引くこと。

---

## 1. 発表FBシート

**発表回（PJ中間発表・最終発表・研究発表）に、聞き手全員がその場で書くピアフィードバックのシート。**授業開始前までに作成してアナウンスする。

> 360°FB（チーム内で相互に書くもの）とは別物。あちらは `hoda-360-feedback` を見る。

### 構造

**1行＝1人の記入者、1チームにつき2列。**

```
行1:  （空）    │ Team1(みかぜ)          │ Team2(ここあ)          │ Team3(りく)  ...
                 └── 2列を結合 ──┘        └── 2列を結合 ──┘
行2:  name      │ 良かったところ │ 質問 or 改善が必要な点 │ 良かったところ │ 質問 or 改善が必要な点 │ ...
行3:  〇〇〇〇  │               │                       │               │                       │
行4:  △△△△  │               │                       │               │                       │
 :
```

| 要素 | 仕様 |
|---|---|
| A列ヘッダー | `name` |
| A列の中身 | **ゼミ生全員の氏名**。名簿の表記をそのまま使う（日本語名／ローマ字が混在してよい） |
| チーム見出し（行1） | **`TeamN(リーダーのニックネーム)`** 形式。2列を結合する |
| 観点（行2） | **`良かったところ`** と **`質問 or 改善が必要な点`** の2列固定 |
| 列の並び | チーム番号順 |

### 運用ルール

- **自分のチームの列には「自分の班」「自チーム」と書いて飛ばす。**空欄にしない（書き忘れと区別がつかなくなる）
- **全チームに書かなくてよい。**空欄は許容されている
- **言語は記入者に合わせる。**日本語話者は日本語、英語話者は英語。同じ人が英語チームには英語で書くのも普通
- **改行を含む長文が入る。**セルの折り返しを有効にしておく
- 観点の粒度は Good / More と同じ思想。**「質問 or 改善が必要な点」を空にしない**のが望ましい

### 生成手順

```python
import openpyxl
from openpyxl.styles import Alignment, Font, PatternFill
from openpyxl.utils import get_column_letter

teams = ["Team1(みかぜ)", "Team2(ここあ)", "Team3(りく)"]   # ← その回の発表チーム
members = ["...", "..."]                                     # ← 名簿から引く

wb = openpyxl.Workbook(); ws = wb.active; ws.title = "FB"
ws.cell(2, 1, "name").font = Font(bold=True)
ws.column_dimensions["A"].width = 18

for i, team in enumerate(teams):
    c = 2 + i * 2
    ws.cell(1, c, team).font = Font(bold=True)
    ws.merge_cells(start_row=1, start_column=c, end_row=1, end_column=c + 1)
    ws.cell(1, c).alignment = Alignment(horizontal="center")
    ws.cell(2, c, "良かったところ").font = Font(bold=True)
    ws.cell(2, c + 1, "質問 or 改善が必要な点").font = Font(bold=True)
    for cc in (c, c + 1):
        ws.column_dimensions[get_column_letter(cc)].width = 42

for r, name in enumerate(members, start=3):
    ws.cell(r, 1, name)
    ws.row_dimensions[r].height = 60

for row in ws.iter_rows(min_row=2, max_row=2 + len(members), max_col=1 + len(teams) * 2):
    for cell in row:
        cell.alignment = Alignment(wrap_text=True, vertical="top")

ws.freeze_panes = "B3"
wb.save("FBシート.xlsx")
```

Googleスプレッドシートで運用する場合は、この .xlsx をDriveにアップロードして変換する。

---

## 2. 輪読マテリアル選定シート

**学期前に、履修選抜課題（＝輪読ファシリ資料）の中からその学期に扱う題材を選ぶためのシート。**授業運営部の3〜5名がそれぞれ評価を書き込み、学期開始3週間前に先生へ共有して先生にも記入してもらう。

### 構造

**1行＝1人の提出者（＝候補題材1つ）。評価者ごとに「記号列＋コメント列」の2列が横に並ぶ。**

```
                                              ├─ 評価者A ─┤├─ 評価者B ─┤ ...  ├─ 保田先生 ─┤
名前 │ 新学年 │ 所属学部 │ 性別 │ 輪読マテリアル │ 元資料 │ 記号 │ コメント │ 記号 │ コメント │ … │ 追記 │ 記号 │ コメント
────┼───────┼─────────┼──────┼──────────────┼───────┼──────┼─────────┼──────┼─────────┼───┼─────┼──────┼─────────
〇〇 │ 4年1学期目 │ 総合政策  │ 女   │ ○○.pdf       │       │  ◎  │ …       │  ◎  │ …       │   │      │ まる │ …
```

| 列 | 内容 |
|---|---|
| **名前 Name** | 提出者 |
| **新学年** | 例：`4年生 1学期目 Senior 1st semester`。**在籍学期数まで書く** |
| **所属学部 Department** | 総合政策 policy management / 環境情報 environment and information studies |
| **性別** | 履修選抜フォームからの引き継ぎ。設問文は「受講生のダイバーシティ確保のための設問です。回答は任意です」 |
| **輪読マテリアル** | 提出されたファシリ資料のファイル名 |
| **元資料** | 原典（論文・ケース・書籍）。提出者が別途挙げていれば入れる |
| **評価者ごとに2列** | 授業運営部メンバー1名につき「記号」＋「コメント」。**ニックネームを列見出しにする** |
| **追記列** | 誰のものでもない共有メモ。「この論点なら別の論文と組み合わせては」など |
| **保田（先生）** | 先生用の「記号」＋「コメント」。**3週間前の共有後に記入してもらう** |

### 評価記号

`◎` / `〇` / `△` / `✕` の4段階。先生は `まる` などテキストで書くこともある。

### コメントに何を書くか

**記号だけで終わらせない。**実際のシートで書かれている判断は、以下の型に分類できる。**これを意識して書くと選定の質が上がる。**

| 判断の型 | 書き方の例 |
|---|---|
| **保田研らしさ** | 「面白いが、ファイナンス要素が無さ過ぎるので見送り」「これは〇〇研がやるもので保田研がやるものじゃないかも」「ファイナンスにもう少し結びつけられれば保田研だからやれる輪読になる」 |
| **輪読向きか** | 「面白いが輪読向きではない」「個人のGPとして深い話を聞きたい」「輪読というより課題図書？」 |
| **DPの質** | 「題材は面白いけどDPがもうちょい盛り上がりそうなら」「このDPで進行して良い議論ができるのかは怪しい」 |
| **難易度と足並み** | 「一定置き去りにされる人が出そう」「かなりテクニカルなので、みんなの足並みを揃える必要がある」「全員の理解が揃った状態で議論した方が有意義」 |
| **新規生への効果** | 「新規生も既存生も学びのある良い題材」「新規生がイベントスタディやその周辺のセオリーに慣れるという意味でも価値が大きい」「輪読ってこんな感じだよ、と新規生に掴んでもらうのに良い」 |
| **他候補との被り** | 「〇〇被り。論点もまあまあ近い」「〇〇のケースと似たような形になりそう」 |
| **組み合わせ・シリーズ化** | 「〇〇のと同時に扱ったら面白そう」「両方を踏まえたキメラを作って1回で回したい」「アクティビストシリーズ①〜⑤」「理論のお勉強シリーズ」「株主還元シリーズ」「みんなで財務分析に強くなろうシリーズ」 |
| **学期内の配置** | 「割と学期前半に扱いたい」「学期後半の方でやりたい」「採用。1週目か2週目に」「前提知識をつけてからでないとレベルが高い」 |
| **日英の割り振り** | 「英語研で面白いかも」「日英両方でできそう」「〇〇を英語のファシリで立てても良いかも」 |
| **ファシリ適性** | 「分析が丁寧だから、DPと構成が練られたらそのまま英語ファシリを任せて良さそう」「ファシリ誰にするかによって結構結果が変わりそう」 |
| **再構成の提案** | 「対象会社がニッチなので、テーマ設定を軸にして再構成した方がわかりやすい」「他に挙げてくれた読み物リストの方を扱いたい」 |

### シート最下部の総括

**個別の評価とは別に、最下部に学期全体の設計に関する議論を書く。**ここが実は一番効く。

```
「個人的に今学期の裏テーマをIRにしたい」
「アクティビストシリーズはどれか一つにしませんか？」
```

**似た題材が集まったらシリーズとしてまとめ、学期の裏テーマを決める。**候補を1本ずつ採否判定するだけでは、学期全体の設計にならない。

### 生成手順

```python
import openpyxl
from openpyxl.styles import Alignment, Font
from openpyxl.utils import get_column_letter

base = ["名前 Name", "新学年", "所属学部 Department",
        "性別（ダイバーシティ確保のための設問。回答は任意）",
        "輪読マテリアル", "元資料"]
raters = ["りく", "みかぜ", "しおり", "まいる", "ここあ"]   # ← 授業運営部メンバー
widths_base = [16, 24, 22, 20, 34, 28]

wb = openpyxl.Workbook(); ws = wb.active; ws.title = "選定"

col = 1
for h, w in zip(base, widths_base):
    ws.cell(1, col, h).font = Font(bold=True)
    ws.column_dimensions[get_column_letter(col)].width = w
    col += 1

for name in raters:                       # 評価者ごとに 記号列 + コメント列
    ws.cell(1, col, name).font = Font(bold=True)
    ws.merge_cells(start_row=1, start_column=col, end_row=1, end_column=col + 1)
    ws.cell(1, col).alignment = Alignment(horizontal="center")
    ws.column_dimensions[get_column_letter(col)].width = 6
    ws.column_dimensions[get_column_letter(col + 1)].width = 46
    col += 2

ws.cell(1, col, "追記").font = Font(bold=True)
ws.column_dimensions[get_column_letter(col)].width = 40
col += 1

ws.cell(1, col, "保田").font = Font(bold=True)   # 先生用
ws.merge_cells(start_row=1, start_column=col, end_row=1, end_column=col + 1)
ws.cell(1, col).alignment = Alignment(horizontal="center")
ws.column_dimensions[get_column_letter(col)].width = 6
ws.column_dimensions[get_column_letter(col + 1)].width = 50

for r in ws.iter_rows(min_row=1, max_row=1, max_col=col + 1):
    for c in r:
        c.alignment = Alignment(wrap_text=True, vertical="center", horizontal="center")
ws.freeze_panes = "B2"
wb.save("輪読マテリアル選定.xlsx")
```

記号列（◎〇△✕）には、Googleスプレッドシート側でデータの入力規則（プルダウン）を設定しておくと入力が揃う。**行の高さは自動にして、コメントは折り返し表示にする。**

## 生成するときに確認すること

Claudeがこれらを生成する前に、ユーザーに確認する。

**FBシート**
- その回に発表するチーム（番号とリーダーのニックネーム）
- 記入者になるゼミ生の一覧（名簿から。**留学・休学セクションは除外**）
- 出力形式（.xlsx か、Googleスプレッドシートに貼れるCSV/TSVか）

**輪読マテリアル選定シート**
- 候補となる提出物の一覧（提出者・題材・資料リンク）
- 評価者になる授業運営部メンバー
