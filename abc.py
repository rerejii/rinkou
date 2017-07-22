# 必要なものをimport
from PIL import Image
import numpy as np
from matplotlib import pylab as plt

x = np.arange(-3, 3, 0.1)
y = np.sin(x)
plt.plot(x, y)
