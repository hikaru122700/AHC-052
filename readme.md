# AHC052: A - Single Controller Multiple Robots

### 概要（問題の要点）
- 盤面: N=30 の N×N グリッド。外周＋一部内部に壁。全マスは連結。
- ロボット: M=10 台。初期位置はすべて異なる。同じマスに重なって可。
- コントローラ: K=10 個のボタン。開始前に「ボタン×ロボット」ごとに U/D/L/R/S を固定設定。実行中の変更不可。
- 実行: ボタンを押すと全ロボットが同時に各自割当の行動を1回実行。壁で移動できない場合は留まる。
- 制限: ボタン押下回数 T ≤ 2N^2（=1800）。
- スコア: 未訪問 R 個。
  - R=0: 3N^2 − T（=2700 − T）。全埋め＆手数少で高スコア。
  - R>0: N^2 − R（=900 − R）。未訪問を減らすほど高スコア。

### ディレクトリ構成（抜粋）
- baseline.py … 参考実装（標準入力→標準出力）
- tools_x86_64-pc-windows-gnu/ … Windows 用ツール（今回は使用しません）
- tools/ … Rust ソース（`cargo build --release` で vis をビルド）
- test.sh … WSL/Linux/mac 用の一括テストスクリプト（uv 経由で baseline.py を実行し、Rust vis で採点）

### baseline.pyの動作解説

このベースラインは「まず正しい形式で出力する最小実装」です。賢い探索はしていませんが、入出力の流れや出力フォーマットを理解するのに最適です。以下では、入力の読み取りから、ボタン割当、操作列の生成、出力までを順に解説します。

1) 入力の読み取り
```python
N, M, K = map(int, input().split())
robots = [list(map(int, input().split())) for _ in range(M)]
v = [list(input()) for _ in range(N)]     # 横の壁情報（N 行、各行 N-1 文字）
h = [list(input()) for _ in range(N-1)]   # 縦の壁情報（N-1 行、各行 N 文字）
```
- 最初の1行で `N M K` を読みます（今回の問題では常に `30 10 10`）。
- 続く M 行で各ロボットの初期位置 `(i, j)` を読みます。
- その後、横方向の壁 `v`、縦方向の壁 `h` を文字列として読み込みます（baseline.pyでは使わないが形式として保持）。

2) ボタン割当（K=10 個の「同時行動テンプレート」）
```python
buttons = []
for i in range(K):
    if i == 0:
        buttons.append(['U']*M)
    elif i == 1:
        buttons.append(['D']*M)
    elif i == 2:
        buttons.append(['L']*M)
    elif i == 3:
        buttons.append(['R']*M)
    else:
        buttons.append(['S']*M)
```
- ボタン 0〜3 は全ロボットに同じ方向（U/D/L/R）を割り当て、4〜9 は全ロボット待機（S）にしています。
- 現状は単純ですが、実際には各ロボットごとに異なる方向を割り当てるとスコアが向上するかもしれません。

3) 操作列の生成（T ≤ 2N^2）
```python
actions_list = []
for _ in range(2*N**2):
    action = random.randint(0, 3)  # 0..3 のボタンをランダムに押す
    actions_list.append(action)
```
- 押すボタンの列（長さ T）を作ります。ここでは最大長の 2N^2 回だけ、0〜3 のいずれかを等確率で選びます。
- 0..3 は先ほどの「全員U/D/L/R」に対応するため、盤面上を無作為に動き回るだけの挙動になります。

4) 出力（フォーマットが最重要）
```python
for button in buttons:
    print(*button)
for action in actions_list:
    print(action)
```
- まず K 行のボタン割当を出力します（行＝ボタンID、列＝ロボットID）。各要素は `U/D/L/R/S` の1文字です。
- 続けて、各ターンに押すボタンID（0..K-1 の整数）を1 行ずつ T 行出力します。T は行数で暗黙に決まります。

#### 現状の動作（baseline.py）
下記は `baseline.py` を可視化したアニメーションです（例）。

![baseline demo](assets/baseline_demo.gif)


### ローカルテストの実行方法

- WSL/Linux/mac: Rust 版 vis をビルドして並列テスト
- 99個のテストケースが自動で走ります
- 以下のスクリプトを実行してください

```bash
bash test.sh
```

- ビジュアライザを見たい場合は以下のサイトにて`ファイルを選択`から`tools/out`ディレクトリを選択してください。

(https://img.atcoder.jp/ahc052/ZN1uhrbm.html?lang=ja&_gl=1)


#### ライセンス/出典
- 問題は こちら（https://atcoder.jp/contests/ahc052/tasks/ahc052_a）