'''
    Script for experimenting with OpenCV tresholds.
'''

import cv2 as cv
import numpy as np
 
img = cv.imread('123.png', cv.IMREAD_GRAYSCALE)
assert img is not None, "file could not be read, check with os.path.exists()"
img = cv.medianBlur(img,5)
 
ret,th1 = cv.threshold(img,127,255,cv.THRESH_BINARY)
th2 = cv.adaptiveThreshold(img,255,cv.ADAPTIVE_THRESH_MEAN_C,\
            cv.THRESH_BINARY,11,2)
th3 = cv.adaptiveThreshold(img,255,cv.ADAPTIVE_THRESH_GAUSSIAN_C,\
            cv.THRESH_BINARY,11,2)
 
titles = ['Original Image', 'Global Thresholding (v = 127)',
            'Adaptive Mean Thresholding', 'Adaptive Gaussian Thresholding']
images = [img, th1, th2, th3]


cv.imwrite('out0.jpg', images[0] )
cv.imwrite('out1.jpg', images[1] )
cv.imwrite('out2.jpg', images[2] )
cv.imwrite('out3.jpg', images[3] )
