function compare_folder(folder, resfolder, params, special_key, show_gt)
if show_gt
    gt_path = [folder, '/GT.jpg'];
end
img_path = [folder, special_key];
params.output_folder = resfolder;
close all;
if show_gt
    figure;
    gt_image = imread(gt_path);
    imshow(gt_image);
end
figure;
image = imread(img_path);
imshow(image);
for i = 1:length(params.rect_position_vis)
    rect = drawrectangle;
    pos = ceil(rect.Position);
    params.rect_position_vis(i) = {pos};
end

close all;
params.img_folder_path = folder;
muti_func_draw_rect(params);
end

