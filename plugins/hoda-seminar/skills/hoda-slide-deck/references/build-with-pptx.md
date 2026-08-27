# python-pptx での実装

## 基本形

```python
from pptx import Presentation
from pptx.util import Inches, Pt

TEMPLATE = "${CLAUDE_PLUGIN_ROOT}/assets/hoda-template.pptx"
prs = Presentation(TEMPLATE)

# テンプレに残っているサンプルスライドを削除する
xml_slides = prs.slides._sldIdLst
for sld in list(xml_slides):
    xml_slides.remove(sld)
```

テンプレには表紙・中表紙・基本スライドのサンプルが3枚入っている。作り始める前に消す。

## レイアウトを名前で引く

インデックスは将来ずれる可能性があるので、名前で引く。

```python
def layout(prs, name):
    for lo in prs.slide_layouts:
        if lo.name == name:
            return lo
    raise KeyError(f"レイアウト '{name}' が見つからない: {[l.name for l in prs.slide_layouts]}")

slide = prs.slides.add_slide(layout(prs, "基本スライド"))
```

## プレースホルダは必ず列挙して確認する

idxの割り当てはレイアウトごとに違う。決め打ちしない。

```python
for ph in slide.placeholders:
    print(ph.placeholder_format.idx, ph.name, ph.text)
```

`基本スライド` の場合：

```python
slide.placeholders[0].text  = "ROICはWACCを3期連続で下回る"      # タイトル
slide.placeholders[11].text = "価値毀損の主因は運転資本回転の悪化にある"  # リード文
slide.placeholders[12].text = "出所：〇〇株式会社「有価証券報告書」（FY2025）よりチーム作成"
```

## 箇条書き（✓と・）

第1階層は `✓`、第2階層は `・`。python-pptx の自動bulletに任せず、**テキストとして書き込む**のが確実。

```python
body = slide.placeholders[10].text_frame
body.clear()

items = [
    (0, "運転資本回転率がFY2020以降一貫して悪化"),
    (1, "DSOが62日から71日へ9日延伸"),
    (1, "DIOが48日から55日へ7日延伸"),
    (0, "固定資産回転率も0.10回低下"),
]
for i, (level, text) in enumerate(items):
    p = body.paragraphs[0] if i == 0 else body.add_paragraph()
    p.text = ("✓ " if level == 0 else "・ ") + text
    p.level = level
```

## 図を貼る

コンテンツプレースホルダの位置とサイズを取って、そこに画像を置く。

```python
ph = slide.placeholders[10]
left, top, width, height = ph.left, ph.top, ph.width, ph.height
ph.element.getparent().remove(ph.element)      # 空プレースホルダを消す
slide.shapes.add_picture("roic_trend.png", left, top, width=width)
```

画像は `transparent=True` で書き出しておくと背景と馴染む。

## チェックリスト（書き出し前）

- [ ] 全スライドで文末に「。」がない（引用を除く）
- [ ] ですます調になっていない
- [ ] 箇条書きが ✓ と ・ になっている
- [ ] 全スライドに出所が入っている
- [ ] 単位が百万円で統一されている
- [ ] グラフに横罫線が入っていない
- [ ] グラフ・表にタイトルが付いている
- [ ] ハイパーリンクがない
- [ ] レイアウト系統（無印／2／3）と配色（無印／青）が混ざっていない
- [ ] 1枚あたりの箇条書きが6行以内
- [ ] （対企業提案なら）その企業のロゴカラーが随所に入っている

自動チェックの例：

```python
import re
for i, s in enumerate(prs.slides):
    for sh in s.shapes:
        if not sh.has_text_frame:
            continue
        for p in sh.text_frame.paragraphs:
            t = "".join(r.text for r in p.runs)
            if t.rstrip().endswith("。") and "「" not in t:
                print(f"S{i+1}: 文末に「。」 -> {t}")
            if re.search(r"(です|ます|ました|ません)$", t.rstrip()):
                print(f"S{i+1}: ですます調 -> {t}")
```
