import numpy as np
from scipy import misc
from PIL import Image
import matplotlib.pyplot as plt

# image = np.array().shape(3,224,224)
# print(np.size(image))

### Function to set all under-zero values to exactly zero.
def negative_to_zero(image: np.array) -> np.array:
    image = image.copy()
    image[image < 0] = 0
    return image

### Function to set all over-255 values to exactly 255.
def over_to_max(image: np.array) -> np.array:
    image = image.copy()
    image[image > 255] = 255
    return image

### Reading the first line of .txt-file to extract dimensions of convolved picture.
sizeof = []
with open('red_convolved_image.txt') as f:
    sizeof1, sizeof2 = f.readline().strip('\n').split(':')
sizeof1 = int(sizeof1.strip())
sizeof2 = int(sizeof2.strip())

print(sizeof1)

### Reading the matrix elements.
red_file = np.loadtxt(open('red_convolved_image.txt', 'rb'), delimiter = None, skiprows = 1)

### Using Numpy.
x = list(red_file)
red_image = np.array(x).astype('uint8')
red_image = np.array(red_image).reshape(sizeof1, sizeof2)

red_image = negative_to_zero(red_image)
# red_image = np.asarray(red_image, dtype=np.uint8)

red_image = np.transpose(red_image)

### Showing the convolved picture.
# red_img = Image.fromarray(red_image)
# red_img.show()

### Reading the matrix elements.
green_file = np.loadtxt(open('green_convolved_image.txt', 'rb'), delimiter = None, skiprows = 1)

### Using Numpy.
x = list(green_file)
green_image = np.array(x).astype('uint8')
green_image = np.array(green_image).reshape(sizeof1, sizeof2)

green_image = negative_to_zero(green_image)

# red_image = np.asarray(red_image, dtype=np.uint8)

green_image = np.transpose(green_image)

### Showing the convolved picture.
# green_img = Image.fromarray(green_image)
# green_img.show()

### Reading the matrix elements.
blue_file = np.loadtxt(open('blue_convolved_image.txt', 'rb'), delimiter = None, skiprows = 1)

### Using Numpy.
x = list(blue_file)
blue_image = np.array(x).astype('uint8')
blue_image = np.array(blue_image).reshape(sizeof1, sizeof2)

blue_image = negative_to_zero(blue_image)

# red_image = np.asarray(red_image, dtype=np.uint8)

blue_image = np.transpose(blue_image)

### Showing the convolved picture.
red_img = Image.fromarray(red_image)
red_img.show()

green_img = Image.fromarray(green_image)
green_img.show()

blue_img = Image.fromarray(blue_image)
blue_img.show()



# edge_image1 = red_image != green_image
# # edge_image = np.logical_and( (red_image == green_image).all(), (green_image == blue_image).all() )
# # print(edge_image1)
# edge_image1 = edge_image1.copy()
# edge_image1[edge_image1 == True] = 255
# edge_image1[edge_image1 != True] = 0

# edge_image2 = green_image != blue_image
# # edge_image = np.logical_and( (red_image == green_image).all(), (green_image == blue_image).all() )
# # print(edge_image2)
# edge_image2 = edge_image2.copy()
# edge_image2[edge_image2 == True] = 255
# edge_image2[edge_image2 != True] = 0

# edge_image3 = edge_image1 != edge_image2
# # edge_image = np.logical_and( (red_image == green_image).all(), (green_image == blue_image).all() )
# # print(edge_image2)
# edge_image3 = edge_image3.copy()
# edge_image3[edge_image3 == True] = 255
# edge_image3[edge_image3 != True] = 0

rgb_image = np.dstack((red_image, green_image, blue_image))

rgb_img = Image.fromarray(rgb_image, 'RGB')
rgb_img.show()

# edge_img1 = Image.fromarray(edge_image1)
# edge_img1.show()

# edge_img2 = Image.fromarray(edge_image2)
# edge_img2.show()

# edge_img3 = Image.fromarray(edge_image3)
# edge_img3.show()