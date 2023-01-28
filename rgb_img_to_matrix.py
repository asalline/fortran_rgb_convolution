import numpy as np
import skimage.io as io
import matplotlib.pyplot as plt

image1 = io.imread('city.jpg')

red = image1[:, :, 0]
green = image1[:, :, 1]
blue = image1[:, :, 2]

def plot_image(image):
    plt.figure(figsize = (10, 10))
    plt.imshow(image)
    plt.show()

red_as_np = np.asarray(red)
img_size1 = str(np.size(red[0]))
img_size2 = str(np.size(np.transpose(red)[0]))
img_size = ','.join([img_size1, img_size2])

green_as_np = np.asarray(green)
blue_as_np = np.asarray(blue)

np.savetxt('red_img.txt', red_as_np, fmt = '%7.2f', header = img_size, comments = '')
np.savetxt('green_img.txt', green_as_np, fmt = '%7.2f', header = img_size, comments = '')
np.savetxt('blue_img.txt', blue_as_np, fmt = '%7.2f', header = img_size, comments = '')