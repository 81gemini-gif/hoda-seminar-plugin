# 保田研プラグイン マーケットプレイス

慶應義塾大学SFC 保田隆明研究会の活動標準を配布するリポジトリ。

> **このリポジトリはPrivateで運用すること。** SPEEDA等の大学契約DBのアクセス手順、ゼミ内部の運用、企業PJの相手先、先生・ゼミ長のメッセージが含まれています。公開しないでください。

---

## ゼミ生向け：インストール方法

Claude Desktop の Cowork、またはチャットで以下を実行します。**最初の一度だけ。**

```
/plugin marketplace add 81gemini-gif/hoda-seminar-plugin
```

続けてプラグインをインストールします。

```
/plugin install hoda-seminar@hoda-seminar
```

以降は、普通に話しかけるだけで該当するスキルが自動で立ち上がります。

```
「〇〇株式会社のROICツリーを作って」
「保田研のテンプレで提案スライドの骨子を組んで」
「合同ゼミの幹事になったんだけど何から始めればいい？」
「360度FBのGoodコメントの下書きを手伝って」
```

### 前提となるコネクタ（任意）

| コネクタ | 用途 |
|---|---|
| **EDINET DB** | 財務時系列、セグメント、有報テキスト、株主構成、統合報告書、中計KPI。財務分析系スキルで実質必須 |
| **Slack** | アナウンスの下書き、幹事チャンネルの確認 |
| **Google Drive** | 名簿、週次シート、引き継ぎ資料、過去の発表資料の参照 |

未接続でもスキルは手順書として機能します。

---

## メンテナ向け：更新方法

### 中身を直す

`plugins/hoda-seminar/` 以下を編集します。

```
plugins/hoda-seminar/
├── .claude-plugin/plugin.json     プラグインのマニフェスト
├── README.md                      収録スキル一覧
├── assets/hoda-template.pptx      保田研共通フォーマット
└── skills/                        19スキル
```

### リリースする

**バージョンを上げないと、ゼミ生の手元に更新が届きません。**2箇所を同じ値に揃えてください。

1. `plugins/hoda-seminar/.claude-plugin/plugin.json` の `version`
2. `.claude-plugin/marketplace.json` の該当プラグインの `version`

その上で push します。

```bash
git add -A
git commit -m "v0.2.0: スライド作法に印刷ルールを追加"
git push
```

### 学期ごとに見直す場所

保田研は学期単位で人が入れ替わります。**引き継ぎのたびに、このリポジトリに何を足すべきかを1つ考えてください。**

| 変わったもの | 直すファイル |
|---|---|
| スライドテンプレート | `assets/hoda-template.pptx` と `skills/hoda-slide-deck/references/template-spec.md` |
| 部署構成・ゼミ長の体制・名簿の列 | `skills/hoda-context/references/org-structure.md` |
| 年間イベントの時期 | `skills/hoda-context/references/annual-cycle.md` |
| 新しい提案先企業・コンペ | `skills/hoda-context/references/glossary.md`、`skills/hoda-onboarding/SKILL.md` |
| 週次スケジュールシートの列構成 | `skills/hoda-weekly-ops/SKILL.md` |
| 使えるデータベース | `skills/hoda-research/SKILL.md`、`skills/hoda-dataset-howto/SKILL.md` |

### 含めてはいけないもの

- **ゼミ生の名簿の実データ**（学籍番号、メールアドレス）。列構成のスキーマのみを収録しています
- 大学契約データベースから取得したデータ（再配布不可）
- 企業から受領した非公開情報

---

## ゼミ生をリポジトリに招待する

GitHub上で Settings → Collaborators から、ゼミ生のGitHubアカウントを追加します。学期ごとに、抜けたメンバーの削除も忘れずに。
