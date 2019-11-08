function muti_func_draw_rect(params)
rect_position_vis = params.rect_position_vis;
img_folder_path = params.img_folder_path;
rect_line_width = params.rect_line_width;
rect_line_color = params.rect_line_color;
output_folder = params.output_folder;
save_each_crop_image = params.save_each_crop_image;
down_margin = params.down_margin;
right_margin = params.right_margin;
mode = params.mode;
scale = params.scale;
margin = params.margin;
pics_each_row = params.pics_each_row;


img_dir = [dir([img_folder_path,'/*.jpg']);...
    dir([img_folder_path,'/*.png']);...
    dir([img_folder_path,'/*.bmp']);...
    dir([img_folder_path,'/*.tif'])];

row_num = ceil(length(img_dir)/pics_each_row);
row_length = 0;
row_pics = [];
if mode == 0    %右侧框
    sum_scale = 0;
    for j = 1:length(rect_position_vis)
        sum_scale = sum_scale + scale(j);
    end
    final_img = [];
    for i = 1:length(img_dir)
        img_path = [img_dir(i).folder,'/',img_dir(i).name];
        img = imread(img_path);
        %img = imresize(img,[1280,768]);
        img_name = split(img_dir(i).name,'.');
        img_part = [];
        for j = 1:length(rect_position_vis)
            p = scale(j) / sum_scale;
            h = (size(img,1) - (length(rect_position_vis) - 1)*down_margin)*p;
            if j == 1
                w =  h * rect_position_vis{j}(3) /rect_position_vis{j}(4);
            else
                rect_position_vis{j}(4) = rect_position_vis{j}(3) * h / w;
            end
            pt = [ceil(rect_position_vis{j}(1)), ceil(rect_position_vis{j}(2))];
            wSize = [ceil(rect_position_vis{j}(3)), ceil(rect_position_vis{j}(4))];
            img_crop = imcrop(img,rect_position_vis{j});      
            img_crop = imresize(img_crop,[h - 2*down_margin,w - 2*right_margin],'cubic');
            if save_each_crop_image ~= 0
                if ~exist(output_folder,'dir')
                   mkdir(output_folder) 
                end
                output_crop_name = [output_folder,'/',img_name{1},'_crop_',int2str(j),'.png'];
                imwrite(img_crop,output_crop_name);
            end
            img = drawRect(img, pt, wSize, rect_line_width, rect_line_color{j}*255);
            if j == 1
                img_part = add_rect(img_crop, down_margin, right_margin, rect_line_color{j});
            else
                temp = add_rect(img_crop, down_margin, right_margin, rect_line_color{j});
                if j ~= length(rect_position_vis)
                    white = ones(down_margin,size(img_part,2),3) * 255;
                else
                    h_ = size(img,1) - size(img_part,1) - size(temp,1);
                    white = ones(h_,size(img_part,2),3) * 255;
                end
                img_part = [img_part; white; temp];
            end
        end
        img_part = imresize(img_part,[size(img,1),size(img_part,2)]);
        white_block = ones([size(img_part,1),margin,3])*255;
        img = [img, white_block, img_part];
        %figure
        %imshow(img);
        imwrite(img,[output_folder,'/',img_name{1},'.png']);
        if i == 1
            row_pics = img;
            row_length = pics_each_row * size(img,2);
        else
            row_pics = [row_pics, img];
        end
        if mod(i,pics_each_row) == 0
            if i/pics_each_row == 1
                final_img = row_pics;
                row_pics = [];
            else
                white = ones(10,row_length,3) * 255;
                final_img = [final_img;white;row_pics];
                row_pics = [];
            end
        else
            if i == length(img_dir)
                if i > pics_each_row
                    whiteX = ceil((row_length - size(row_pics,2))/2);
                    white = ones(size(row_pics,1),whiteX,3) * 255;
                    row_pics = [white,row_pics];
                    white = ones(size(row_pics,1),row_length - size(row_pics,2),3) * 255;
                    row_pics = [row_pics,white];
                    white = ones(10,size(row_pics,2),3) * 255;
                    final_img = [final_img;white;row_pics];
                else
                    final_img = row_pics;
                end
            end
        end
    end
end

if mode == 1   %下侧框
    sum_scale = 0;
    for j = 1:length(rect_position_vis)
        sum_scale = sum_scale + scale(j);
    end
    final_img = [];
    for i = 1:length(img_dir)
        img_path = [img_dir(i).folder,'/',img_dir(i).name];
        img = imread(img_path);
        if i == 1
            row_length = pics_each_row * size(img,2);
        end
        img_name = split(img_dir(i).name,'.');
        img_part = [];       
        for j = 1:length(rect_position_vis)
            p = scale(j) / sum_scale;
            w = (size(img,2) - margin*(length(rect_position_vis) - 1))*p;
            if j == 1
                h =  w * rect_position_vis{j}(4) /rect_position_vis{j}(3);
            else
                rect_position_vis{j}(3) = rect_position_vis{j}(4) * w / h;
            end
            pt = [ceil(rect_position_vis{j}(1)), ceil(rect_position_vis{j}(2))];
            wSize = [ceil(rect_position_vis{j}(3)), ceil(rect_position_vis{j}(4))];
            img_crop = imcrop(img,rect_position_vis{j});      
            img_crop = imresize(img_crop,[h - 2*down_margin,w - 2*right_margin],'cubic');
            if save_each_crop_image ~= 0
                if ~exist(output_folder,'dir')
                   mkdir(output_folder) 
                end
                output_crop_name = [output_folder,'/',img_name{1},'_crop_',int2str(j),'.png'];
                imwrite(img_crop,output_crop_name);
            end
            img = drawRect(img, pt, wSize, rect_line_width, rect_line_color{j}*255);
            if j == 1
                img_part = add_rect(img_crop, down_margin, right_margin, rect_line_color{j});
            else
                temp = add_rect(img_crop, down_margin, right_margin, rect_line_color{j});
                if j ~= length(rect_position_vis)
                    white = ones(size(img_part,1), right_margin,3) * 255;
                    
                else
                    w_ = size(img,2) - size(img_part,2) - size(temp,2);
                    white = ones(size(img_part,1), w_,3) * 255;
                end
                img_part = [img_part, white, temp];
            end
        end
        img_part = imresize(img_part,[size(img_part,1),size(img,2)]);
        white_block = ones([margin, size(img_part,2),3])*255;
        img = [img; white_block; img_part];
        %figure
        %imshow(img);
        imwrite(img,[output_folder,'/',img_name{1},'.png']);
        if i == 1
            row_pics = img;
        else
            row_pics = [row_pics, img];
        end
        if mod(i,pics_each_row) == 0
            if i/pics_each_row == 1
                final_img = row_pics;
                row_pics = [];
            else
                white = ones(10,row_length,3)*255;
                final_img = [final_img;white;row_pics];
                row_pics = [];
            end
        end
        if i == length(img_dir) && mod(i,pics_each_row) ~= 0
            if i <= pics_each_row
                final_img = row_pics;
            else
                n = mod(i,pics_each_row);
                if n == 0
                    white = ones(10,row_length,3)*255;
                    final_img = [final_img;white;row_pics];
                else
                    whiteX = ceil((row_length - size(row_pics,2))/2.0);
                    white = ones(size(row_pics,1),whiteX,3)*255;
                    row_pics = [white,row_pics];
                    white = ones(size(row_pics,1),row_length - size(row_pics,2),3)*255;
                    row_pics = [row_pics,white];
                    white = ones(10,row_length,3)*255;
                    final_img = [final_img;white;row_pics];
                end
            end
        end
    end
end

if mode == 2   %只画框
    row_pics = [];
    for i = 1:length(img_dir)
        img_path = [img_dir(i).folder,'/',img_dir(i).name];
        img = imread(img_path);
        img_name = split(img_dir(i).name,'.');
        for j = 1:length(rect_position_vis)
            pt = [ceil(rect_position_vis{j}(1)), ceil(rect_position_vis{j}(2))];
            wSize = [ceil(rect_position_vis{j}(3)), ceil(rect_position_vis{j}(4))];
            img = drawRect(img,pt,wSize,rect_line_width, rect_line_color{j}*255);    
        end
        imwrite(img,[output_folder,'/',img_name{1},'.png'])
        if i == 1
            row_length = size(img,2)*pics_each_row;
            row_pics = img;
        else
            row_pics = [row_pics,img];
        end 
        if mod(i,pics_each_row) == 0
            if i/pics_each_row == 1
                final_img = row_pics;
                row_pics = [];
            else
                white = ones(10,row_length,3) * 255;
                final_img = [final_img;white;row_pics];
                row_pics = [];
            end
        else
            if i == length(img_dir)
                if i > pics_each_row
                    whiteX = ceil((row_length - size(row_pics,2))/2);
                    white = ones(size(row_pics,1),whiteX,3) * 255;
                    row_pics = [white,row_pics];
                    white = ones(size(row_pics,1),row_length - size(row_pics,2),3) * 255;
                    row_pics = [row_pics,white];
                    final_img = [final_img;row_pics];
                else
                    final_img = row_pics;
                end
            end
        end
    end
end


if mode == 3   %在里面
    sum_scale = 0;
    for j = 1:length(rect_position_vis)
        sum_scale = sum_scale + scale(j);
    end
    final_img = [];
    for i = 1:length(img_dir)
        img_path = [img_dir(i).folder,'/',img_dir(i).name];
        img = imread(img_path);
        if i == 1
            row_length = pics_each_row * size(img,2);
        end
        img_name = split(img_dir(i).name,'.');
        img_part = [];       
        for j = 1:length(rect_position_vis)
            p = scale(j) / sum_scale;
            w = (size(img,2) - margin*(length(rect_position_vis) - 1))*p;
            if j == 1
                h =  w * rect_position_vis{j}(4) /rect_position_vis{j}(3);
            else
                rect_position_vis{j}(3) = rect_position_vis{j}(4) * w / h;
            end
            pt = [ceil(rect_position_vis{j}(1)), ceil(rect_position_vis{j}(2))];
            wSize = [ceil(rect_position_vis{j}(3)), ceil(rect_position_vis{j}(4))];
            img_crop = imcrop(img,rect_position_vis{j});      
            img_crop = imresize(img_crop,[h - 2*down_margin,w - 2*right_margin],'cubic');
            if save_each_crop_image ~= 0
                if ~exist(output_folder,'dir')
                   mkdir(output_folder) 
                end
                output_crop_name = [output_folder,'/',img_name{1},'_crop_',int2str(j),'.png'];
                imwrite(img_crop,output_crop_name);
            end
            img = drawRect(img, pt, wSize, rect_line_width, rect_line_color{j}*255);
            if j == 1
                img_part = add_rect(img_crop, down_margin, right_margin, rect_line_color{j});
            else
                temp = add_rect(img_crop, down_margin, right_margin, rect_line_color{j});
                img_part = [img_part, temp];
            end
        end
        img_part = imresize(img_part,[size(img_part,1),size(img,2)]);
        %img = [img; white_block; img_part];
        
        img = replace_img(img,img_part,params.radius,params.side);
        imwrite(img,[output_folder,'/',img_name{1},'.png']);
        if i == 1
            row_pics = img;
        else
            row_pics = [row_pics, img];
        end
        if mod(i,pics_each_row) == 0
            if i/pics_each_row == 1
                final_img = row_pics;
                row_pics = [];
            else
                white = ones(10,row_length,3)*255;
                final_img = [final_img;white;row_pics];
                row_pics = [];
            end
        end
        if i == length(img_dir) && mod(i,pics_each_row) ~= 0
            if i <= pics_each_row
                final_img = row_pics;
            else
                n = mod(i,pics_each_row);
                if n == 0
                    white = ones(10,row_length,3)*255;
                    final_img = [final_img;white;row_pics];
                else
                    whiteX = ceil((row_length - size(row_pics,2))/2.0);
                    white = ones(size(row_pics,1),whiteX,3)*255;
                    row_pics = [white,row_pics];
                    white = ones(size(row_pics,1),row_length - size(row_pics,2),3)*255;
                    row_pics = [row_pics,white];
                    white = ones(10,row_length,3)*255;
                    final_img = [final_img;white;row_pics];
                end
            end
        end
    end
end


figure
imshow(final_img)
end



function res = add_rect(img,up_size,right_size,color)
    up_bar = ones([up_size,size(img,2) + 2 * right_size,3]);
    right_bar = ones([size(img,1),right_size,3]);
    for c = 1:3
        up_bar(:,:,c) = up_bar(:,:,c) * color(c) * 255;
        right_bar(:,:,c) = right_bar(:,:,c) * color(c) * 255;
    end
    res = [right_bar, img, right_bar];
    res = [up_bar; res; up_bar];
end

function res = replace_img( img, img_part, radius, str)
    res = img;
    [H, W, C] = size(img);
    [h, w, c] = size(img_part);
    r = h/w;
    part = imresize(img_part,[ceil(W*radius*r), ceil(W*radius)]);

    if str == 0
        res(H - ceil(W*radius*r) + 1 : H, 1 : ceil(W*radius), :) = part;
    end
    if str == 1
        res(H - ceil(W*radius*r) + 1 : H, W - ceil(W*radius) + 1 : W, :) = part;
    end
    if str == 2
        res(1 : ceil(W*radius*r), W - ceil(W*radius) + 1 : W, :) = part;
    end
    if str == 3
        res(1 : ceil(W*radius*r), 1 : ceil(W*radius), :) = part;
    end
end


