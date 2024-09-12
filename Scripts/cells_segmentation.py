'''
	Script for experiments with Watershed OpenCV utility (boundary detection).
'''

import numpy as np
import cv2 as cv
import PIL.Image

img_name = '123.png'
img = cv.imread(img_name)
gray = cv.imread(img_name, cv.IMREAD_GRAYSCALE)
ret,thresh = cv.threshold(gray,127,255,cv.THRESH_BINARY)

# noise removal
kernel = np.ones((3,3),np.uint8)
opening = cv.morphologyEx(thresh,cv.MORPH_OPEN,kernel, iterations = 2)
 
# sure background area
sure_bg = cv.dilate(opening,kernel,iterations=3)

# Finding sure foreground area
dist_transform = cv.distanceTransform(opening,cv.DIST_L2,5)
ret, sure_fg = cv.threshold(dist_transform,0.03*dist_transform.max(),255,0)

# Finding unknown region
sure_fg = np.uint8(sure_fg)
unknown = cv.subtract(sure_bg,sure_fg)



# Marker labelling
ret, markers = cv.connectedComponents(sure_fg)

# Add one to all labels so that sure background is not 0, but 1
markers = markers+1
 
# Now, mark the region of unknown with zero
markers[unknown==255] = 0


markers = cv.watershed(img,markers)

h,w,c = img.shape
img_out = np.zeros((h,w,3), dtype=np.uint8)
img_out[markers == -1] = [0,255,0]

cv.imwrite('out.jpg', img_out )
