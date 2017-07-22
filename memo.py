#coding:utf-8

import numpy as np
import cv2

img = cv2.imread("lenna256.png")
#画像をグレースケールに変換
gray = cv2.cvtColor(img,cv2.COLOR_RGB2GRAY)

#ヒストグラムを作成
histgram = [0]*256
for i in range(0,len(gray)):
	for j in range(0,len(gray[0])):
		histgram[gray[i][j]] += 1

#print histgram

max_t = max_val = 0

#判別分析法を使って2値化
for t in range(0,256):

	#画素数
	w1 = w2 = 0

	#クラス別合計値
	sum1 = sum2 = 0

	#クラス別平均
	m1 = m2 = 0.0

	for i in range(0,t):
		w1 += histgram[i]
		sum1 += i*histgram[i]

	for j in range(t,256):
		w2 += histgram[j]
		sum2 += j*histgram[j]

	#0除算を防ぐ
	if w1 == 0 or w2 == 0:
		continue

	#クラス別平均の算出
	m1 = sum1/w1
	m2 = sum2/w2

	#結果を算出
	result = w1*w2*(m1-m2)*(m1-m2)

	if max_val < result:
		max_val = result
		max_t = t


for i in range(0,len(gray)):
	for j in range(0,len(gray[0])):

		if(gray[i][j] < max_t):
			gray[i][j] = 0
		else:
			gray[i][j] = 255

#print max_val
#cv2.imwrite("binary_lenna.png",gray)
cv2.imshow("binary",gray)
cv2.waitKey(0)
cv2.destroyAllWindow()
