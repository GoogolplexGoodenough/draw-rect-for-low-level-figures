a = imread('result.png');
b = imread('blur001.png');
res = replay_leftdown(a,b,0.2);
imshow(res)








function res = replay_leftdown( img, img_part, radius)
    [H, W, C] = size(img);
    [h, w, c] = size(img_part);
    r = h/w;
    part = imresize(img_part,[ceil(W*radius*r), ceil(W*radius)]);
    img(H - ceil(W*radius*r) + 1 : H, 1 : ceil(W*radius), :) = part;
    res = img;
end