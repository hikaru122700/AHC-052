AHC052: A - Single Controller Multiple Robots（ローカル環境メモ）

概要（問題の要点）
- 盤面: N=30 の N×N グリッド。外周＋一部内部に壁。全マスは連結。
- ロボット: M=10 台。初期位置はすべて異なる。同じマスに重なって可。
- コントローラ: K=10 個のボタン。開始前に「ボタン×ロボット」ごとに U/D/L/R/S を固定設定。実行中の変更不可。
- 実行: ボタンを押すと全ロボットが同時に各自割当の行動を1回実行。壁で移動できない場合は留まる。
- 制限: ボタン押下回数 T ≤ 2N^2（=1800）。
- スコア: 未訪問 R 個。
  - R=0: 3N^2 − T（=2700 − T）。全埋め＆手数少で高スコア。
  - R>0: N^2 − R（=900 − R）。未訪問を減らすほど高スコア。

ディレクトリ構成（抜粋）
- baseline.py … 参考実装（標準入力→標準出力）
- tools_x86_64-pc-windows-gnu/ … Windows 用ツール（今回は使用しません）
- tools/ … Rust ソース（`cargo build --release` で vis をビルド）
- test.sh … WSL/Linux/mac 用の一括テストスクリプト（uv 経由で baseline.py を実行し、Rust vis で採点）

ローカルテストの実行方法

- WSL/Linux/mac: Rust 版 vis をビルドして並列テスト
- 99個のテストケースが自動で走ります
- ビジュアライザを見たい場合はこちらのサイト(https://img.atcoder.jp/ahc052/ZN1uhrbm.html?lang=ja&_gl=1)にて`ファイルを選択`から`tools/out`ディレクトリを選択してください。

スクリーンショット

以下はビジュアライザの表示例です。画像をクリックすると公式ビジュアライザが開きます。

<a href="https://img.atcoder.jp/ahc052/ZN1uhrbm.html?lang=ja" target="_blank">
  <img src="assets/visualizer_sample.png" alt="Visualizer Screenshot" width="420" />
  
</a>

```bash
bash test.sh
```



ライセンス/出典
- 問題は こちら（https://atcoder.jp/contests/ahc052/tasks/ahc052_a）