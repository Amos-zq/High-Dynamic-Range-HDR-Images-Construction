clear all;

%% Parameters %%%
fileName = 'room';
dir = '../room/';
files = {'room_1_60.JPG', 'room_1_30.JPG', 'room_1_15.JPG', 'room_1_8.JPG', 'room_1_4.JPG', ...
         'room_1_2.JPG', 'room_1.JPG', 'room_2.JPG', 'room_4.JPG', 'room_8.JPG'};
apertures = [1/60, 1/30, 1/15, 1/8, 1/4, 1/2, 1, 2, 4, 8];

totalImages = size(files, 2);
B = log(apertures);
l = 30;
w = [linspace(0.02,1,128),linspace(1,0.02,128)];
a = 0.3;

I = imread([dir,files{1}]);
[height,width,~] = size(I);
I = zeros(height,width,3,totalImages);

for i=1:totalImages
    I(:,:,:,i) = imread([dir,files{i}]);
end

%% Alignment
disp('Alignment');
tic;
img_aligned = zeros(height,width,3,totalImages);
img_aligned(:,:,:,1) = I(:,:,:,1);
shift = cell(totalImages,1);
shift{1} = [0, 0];
for i = 2: totalImages
    [img_aligned(:,:,:,i), shift{i}] = alignment(I(:,:,:,1), I(:,:,:,i));
end
toc;
I = img_aligned;

tic;
%%
%Check selected point file
if exist(['hdr_',fileName,'.mat'],'file')
    load(['hdr_',fileName,'.mat']);
else
    imshow(I(:,:,:,8));
    [x,y] = ginput(25);
%     x = randi(width-1,50,1);
%     y = randi(height-1,50,1);
    y = round(y);
    x = round(x);
    save(['hdr_',fileName,'.mat'],'x','y');
end
%%
%Assign selected pixel values from different pictures to RGB channels
p = size(x,1);%number of points selected
points_R = zeros(p, totalImages);
points_G = zeros(p, totalImages);
points_B = zeros(p, totalImages);

for i=1:totalImages %number of pictures
    for j=1:p %number of points selected
        points_R(j,i) = I(y(j),x(j),1,i);
        points_G(j,i) = I(y(j),x(j),2,i);
        points_B(j,i) = I(y(j),x(j),3,i);
    end
end

%%
%Slove g and lnE of RGB channels
g = zeros(256,3);
[g(:,1),lnE_R] = gsolve(points_R,B,l,w);
[g(:,2),lnE_G] = gsolve(points_G,B,l,w);
[g(:,3),lnE_B] = gsolve(points_B,B,l,w);


%plot(g(:, 1), 0:255, 'R', g(:, 2), 0:255, 'G', g(:, 3), 0:255,'B');
%figure;

 %%
hdr_image = zeros(height,width,3);
hdr_image = avg_map(I,w,B,g,totalImages);
newlE = hdr_image;
hdr_image = exp(hdr_image);
hdrwrite(hdr_image, 'room.hdr')
 
%hdrwrite(hdr_image,'room.hdr');

Ld = tone_mapping(hdr_image,a);
imwrite(Ld, 'room_tonemap.jpg')
toc;

%imshow(Ld);








