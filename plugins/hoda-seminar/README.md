# 保田研究会プラグイン

慶應義塾大学SFC 保田隆明研究会の活動標準を共有するためのプラグイン。輪読・プロジェクトワーク・ゼミ運営の三本柱で、これまで口頭とスプレッドシートに散らばっていた型を、いつでも引き出せる形にまとめてある。

**Hoda Seminar Plugin** — Working standards for the Hoda Seminar at Keio University SFC. Skills are written in Japanese because the seminar's working documents are in Japanese; if you prefer English, just say so and Claude will produce English deliverables while following the same standards.

---

## 収録スキル

### 基盤

| スキル | 何をするか |
|---|---|
| **hoda-context** | 保田研の前提知識。用語集、組織構造、名簿スキーマ、年間サイクル、行動規範（ATI・ラストマンシップ）、成果物の水準 |
| **hoda-onboarding** | 新規生・出戻り生へのオンボーディング。学期頭のレクチャー資料の構成もここ |

### 財務分析

| スキル | 何をするか |
|---|---|
| **hoda-company-scan** | 企業分析の入口。EDINET DBから財務・非財務を一括取得して初期スキャン |
| **hoda-value-driver-tree** | ROICツリーの作成とROEデュポン分解（3分解／5分解） |
| **hoda-peer-benchmark** | 競合との10〜20年時系列比較。財務・株価・マルチプルの3層 |
| **hoda-valuation** | DCF・マルチプル・SOTPでのバリュエーション。フットボールチャート |
| **hoda-cross-swot** | クロスSWOTで打ち手に落とし、財務ドライバーに接続する |

### リサーチ・実証分析

| スキル | 何をするか |
|---|---|
| **hoda-research** | リサーチの掟。情報ソース一覧、SPEEDA/Capital IQのアクセス方法、開示書類の読み方、生成AIの使い方 |
| **hoda-empirical-roadmap** | 実証分析の初学者向けロードマップ（R前提）。RQの立て方から回帰の読み方まで |
| **hoda-dataset-howto** | データセットの集め方・作り方。企業コードの名寄せなど実務的な落とし穴 |

### スライド・提案

| スキル | 何をするか |
|---|---|
| **hoda-slide-deck** | 保田研テンプレでスライドを作る。デッキ構成、エグゼクティブサマリーの書き方、全スライド作法 |
| **hoda-kimehen** | キメヘン（キ＝聞き手／メ＝メインメッセージ／ヘン＝起こしたい変化） |
| **hoda-presentation-readiness** | 対外発表前の逆算スケジュールと当日チェック |

### プロジェクトワーク

| スキル | 何をするか |
|---|---|
| **hoda-project-leader** | PJリーダーの手引き。学期の流れ、週次の回し方、詰まったときの判断 |
| **hoda-360-feedback** | 360°FBのGoodコメント／Moreコメントの書き方 |

### ゼミ運営

| スキル | 何をするか |
|---|---|
| **hoda-zemicho-assistant** | ゼミ長の伴走。役割分担、週次の確認項目、合ゼミの監視、引き継ぎ |
| **hoda-semester-plan** | 学期スケジュールの設計。外部固定日程から逆算してシートを初期化する |
| **hoda-weekly-ops** | 週次運営。スケジュールシートの列構成、輪読コンテンツの決め方、ファシリのやり方 |
| **hoda-event-kanji** | イベント幹事の手引き。合同ゼミ、合宿、工場見学、講演会、引き継ぎメモ |

---

## 同梱アセット

- `assets/hoda-template.pptx` — 保田研共通フォーマット（スライドマスター）。16:9、20レイアウト、テーマカラーとフォント設定済み

---

## 前提となるコネクタ

| コネクタ | 用途 | 必須か |
|---|---|---|
| **EDINET DB** | 財務時系列、セグメント、販管費内訳、有報テキスト、株主構成、政策保有株、役員報酬、IR資料、中計KPI | 財務分析系スキルで実質必須 |
| **Slack** | アナウンス下書き、幹事チャンネルの確認、議事の共有 | 運営系スキルであると便利 |
| **Google Drive** | 名簿、週次シート、引き継ぎ資料、過去の発表資料の参照 | 運営系スキルであると便利 |

コネクタが未接続でも、スキル自体は手順書として機能する。

---

## 含まれていないもの（意図的）

**ゼミ生の名簿の実データは含まれていない。**学籍番号とメールアドレスは個人情報のため、プラグインには**列構成（スキーマ）だけ**を収録している。実データはGoogle DriveまたはSlackにある最新版を都度参照すること。

同様に、大学契約データベース（日経NEEDS、Bloomberg、Refinitiv、SPEEDA、Capital IQ）から取得したデータは再配布不可のため、アクセス方法のみを記載している。

---

## 更新するとき

保田研は学期単位で人が入れ替わる。**このプラグインも学期ごとに更新する前提で作ってある。**

更新すべきタイミング：

- スライドテンプレートが変わったとき → `assets/hoda-template.pptx` を差し替え、`hoda-slide-deck/references/template-spec.md` を更新
- 部署構成・ゼミ長の体制が変わったとき → `hoda-context/references/org-structure.md`
- 年間の主要イベントの時期が変わったとき → `hoda-context/references/annual-cycle.md`
- 新しい提案先企業・コンペに取り組んだとき → `hoda-context/references/glossary.md` と `hoda-onboarding`
- 週次シートの列構成が変わったとき → `hoda-weekly-ops`

**引き継ぎのたびに、このプラグインに何を足すべきかを1つ考える。**それがゼミの資産になる。
