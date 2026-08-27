# 保田研のチャート作法

## 配色（テンプレのテーマカラー）

| 用途 | HEX | 備考 |
|---|---|---|
| 自社・主役 | `#243E4D` | 濃紺。太線（2.5pt） |
| 強調・注目 | `#FE802C` | オレンジ。1系列だけに使う |
| 補助1 | `#FCC949` | イエロー |
| 補助2 | `#A1C182` | グリーン |
| 補助3 | `#589C87` | ティール |
| 補助4 | `#31BCB7` | シアン |
| 脇役・競合 | `#E8E8E8` | 薄グレー。細線（1pt） |
| 文字 | `#3A3A3A` | 濃グレー |

原則：**主役1色＋強調1色＋残り全部グレー。** 6色使うのは、6つとも同等に見せたいときだけ。

対企業提案のときは、**随所にその企業のコーポレートカラーを仕込む。**自社（提案先）の系列をその企業のブランドカラーにするのが定石。

## 線・軸

- 横罫線（グリッド線）は入れない。どうしても必要なら `#E8E8E8` の極細。
- 上・右のスパイン（枠線）は消す。
- 凡例ボックスは使わず、線の右端に系列名を直接置く。
- Y軸の0起点：金額・件数は0起点必須。指数化した株価やマルチプルは0起点でなくてよいが、その旨が読み取れるようにする。

## ラベル・単位

- 金額系の単位は**百万円**に統一。「（百万円）」をY軸ラベルまたはグラフタイトル横に置く。
- 率は「%」、変化幅は「pt」、回転は「回」「日」。
- 桁区切りのカンマを入れる。
- 年度は FY2016 形式。和暦は使わない。

## タイトルと出典

- グラフには**何を示した図か分かるタイトル**を付ける。「売上高推移」ではなく「主要5社の売上高推移（FY2016-FY2025）」。
- 出所はスライド左下のテキストボックスに `出所：〜` の形式で入れる。ハイパーリンクにはしない（テキストとしてURLを書くのは可）。

## matplotlib テンプレート

```python
import matplotlib
import matplotlib.pyplot as plt

matplotlib.rcParams.update({
    'font.family': ['Noto Sans CJK JP', 'IPAexGothic', 'sans-serif'],
    'axes.spines.top': False,
    'axes.spines.right': False,
    'axes.grid': False,
    'figure.dpi': 200,
})

HODA = {'main': '#243E4D', 'accent': '#FE802C', 'grey': '#E8E8E8', 'text': '#3A3A3A'}

fig, ax = plt.subplots(figsize=(10, 5.5))
for name, series in peers.items():          # 競合は先に薄く描く
    ax.plot(years, series, color=HODA['grey'], lw=1.0, zorder=1)
    ax.annotate(name, (years[-1], series[-1]), xytext=(4, 0),
                textcoords='offset points', va='center',
                fontsize=9, color=HODA['grey'])
ax.plot(years, own, color=HODA['main'], lw=2.5, zorder=3)
ax.annotate('当社', (years[-1], own[-1]), xytext=(4, 0),
            textcoords='offset points', va='center',
            fontsize=10, color=HODA['main'])
ax.set_title('主要5社のROIC推移（FY2016-FY2025）', color=HODA['text'], loc='left')
ax.set_ylabel('（%）', color=HODA['text'])
ax.margins(x=0.12)                          # 右端ラベルの逃げを作る
fig.savefig('roic_trend.png', bbox_inches='tight', transparent=True)
```

`transparent=True` で書き出すと、スライドの背景色を問わず貼れる。

## スライドへの貼り方

- グラフは画像として貼る。PowerPoint側でグラフオブジェクトを作らない（テンプレの書式と喧嘩する）。
- 「基本スライド」レイアウトのコンテンツプレースホルダ（幅12.36in × 高4.85in、左0.49in／上2.06in）に収まるサイズで書き出す。2列レイアウトなら片側5.79in幅。
