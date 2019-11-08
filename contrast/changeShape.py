import cv2 as cv
import glob

img_path = glob.glob('./*.jpg')
for i in range(len(img_path)):
    img = cv.imread(img_path[i])

    img = cv.resize(img,(1920,1080))
    cv.imwrite(img_path[i],img)