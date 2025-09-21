import random

N, M, K = map(int, input().split())

# ロボットの位置をリストで受け取る
robots = [list(map(int, input().split())) for _ in range(M)]

# 障害物の配置を受け取る
v = [list(input()) for _ in range(N)]
h = [list(input()) for _ in range(N-1)]

move_dict = {'R': (0, 1), 'L': (0, -1), 'U': (-1, 0), 'D': (1, 0)}


# ボタンの割り当てをする
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

# 操作列
actions_list = []
for _ in range(2*N**2):
    # 0~3のランダムな整数を選ぶ
    action = random.randint(0, 3)
    actions_list.append(action)

# 出力
for button in buttons:
    print(*button)
for action in actions_list:
    print(action)
