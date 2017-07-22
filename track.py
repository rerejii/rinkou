# 必要なものをimport
from PIL import Image
import numpy as np
from matplotlib import pylab as plt

# 画像の読み込み
img = np.array( Image.open('mohu.png') )
# 画像の表示
im = Image.open('mohu.png')

plt.imshow( img )
r = img[:,:,0]
g = img[:,:,1]
b = img[:,:,2]
a = img[:,:,3]
img_ntsc = (0.298912 * r + 0.586611 * g + 0.114478 * b)
plt.imshow(img_ntsc)
#print (img[:,:,3])
#print (img[:,1])
#im.show()
