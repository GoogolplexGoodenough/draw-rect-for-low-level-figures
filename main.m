image_folders_path = 'E:\ICME2023\results\output_ufo_sorted_by_image\2x';
image_folders = dir([image_folders_path, '\\*']);
image_length = length(image_folders);
resfolder_path = 'E:\ICME2023\results\output_ufo_sorted_by_image\2x_compare';
special_key = '/Ours.jpg';

params = generate_params('./contrast',[{[200,100,100,80]},{[800,400,100,80]}]);
params.output_folder = './result';
params.mode = 1;
params.pics_each_row = 3;
params.rect_line_width = 5;
params.save_each_crop_image = 0;
params.scale = [3 3];
params.down_margin = 10;
params.right_margin = 10;
params.margin = 10;
params.side = 0;
%params.radius = 0.8;

for i=1:image_length
    image_folder = image_folders(i);
    if strcmp(image_folder.name, '.')
        continue
    end
    if strcmp(image_folder.name, '..')
        continue
    end
    resfolder = [resfolder_path, '/', image_folder.name];
    if exist(resfolder) > 0
        continue
    end
    mkdir(resfolder);
    image_folder = [image_folder.folder, '/', image_folder.name];
    compare_folder(image_folder, resfolder, params, special_key, true);
end
