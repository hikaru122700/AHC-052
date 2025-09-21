#!/bin/bash
# Usage: bash test.sh [solution.py]
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TOOLS_DIR="$SCRIPT_DIR/tools"
IN_DIR="$TOOLS_DIR/in"
OUT_DIR="$TOOLS_DIR/out"
VIS_DEBUG="$TOOLS_DIR/target/debug/vis"
VIS_RELEASE="$TOOLS_DIR/target/release/vis"

# 解答スクリプト（引数がなければ baseline.py）
SOL_ARG="${1:-baseline.py}"
if [[ "$SOL_ARG" = /* ]]; then
  SOL_PATH="$SOL_ARG"
else
  SOL_PATH="$SCRIPT_DIR/$SOL_ARG"
fi
if [[ ! -f "$SOL_PATH" ]]; then
  echo "solution not found: $SOL_PATH"
  exit 1
fi

rm -rf "$OUT_DIR"
mkdir -p "$OUT_DIR"

# ビルド（未ビルド時のみ）
if [ ! -x "$VIS_RELEASE" ] && [ ! -x "$VIS_DEBUG" ]; then
  if ! command -v cargo >/dev/null 2>&1; then
    echo "cargo が見つかりません。Rust をインストールしてください (https://rustup.rs)"
    exit 1
  fi
  echo "Building vis (release)..."
  (cd "$TOOLS_DIR" && cargo build --release)
fi

if [ -x "$VIS_RELEASE" ]; then
  VIS="$VIS_RELEASE"
elif [ -x "$VIS_DEBUG" ]; then
  VIS="$VIS_DEBUG"
else
  echo "vis バイナリが見つかりません: $VIS_RELEASE または $VIS_DEBUG"
  exit 1
fi

# uv の存在確認（要求どおり、Python実行は uv 経由に統一）
if ! command -v uv >/dev/null 2>&1; then
  echo "uv が見つかりません。uv をインストールしてください (https://docs.astral.sh/uv/)"
  exit 1
fi

echo "uv    : $(command -v uv)"
echo "vis   : $VIS"
echo "solve : $SOL_PATH"

# 解答実行（並列）
P=$(nproc 2>/dev/null || sysctl -n hw.ncpu 2>/dev/null || echo 4)
seq 0 99 \
  | xargs -I@ printf "%s\\n" @ \
  | xargs -n1 -P"$P" -I@ bash -c '
      set -euo pipefail
      ID=$(printf "0%03d" "$2")
      uv run python "$1" < "'$IN_DIR'/$ID.txt" > "'$OUT_DIR'/$ID.txt"
    ' _ "$SOL_PATH" @

# スコア集計
echo "\n=== Scores per ID ==="
SUM=0
for S in $(seq 0 99); do
  ID=$(printf "0%03d" "$S")
  OUT=$("$VIS" "$IN_DIR/$ID.txt" "$OUT_DIR/$ID.txt" 2>&1 || true)
  SCORE=$(printf "%s" "$OUT" | sed -E 's/.*[Ss]core[[:space:]]*=[[:space:]]*([-]?[0-9]+).*/\1/;t;d')
  if [[ ! "$SCORE" =~ ^-?[0-9]+$ ]]; then SCORE=0; fi
  printf "ID %s  Score: %d\n" "$ID" "$SCORE"
  SUM=$((SUM + SCORE))
done
echo "=== Summary ==="
echo "Total Score: $SUM"