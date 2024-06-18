% Ask the user to select the original or test image for the first image
answer1 = questdlg('Which image are you selecting for the first image?', ...
    'Image Selection', ...
    'Original','Test','Cancel','Original');

switch answer1
    case 'Original'
        original_or_test_1 = 'Original';
    case 'Test'
        original_or_test_1 = 'Test';
    case 'Cancel'
        disp('User selected Cancel');
        return;
end

% Let the user choose the first image
[filename1, pathname1] = uigetfile({'*.jpeg;*.jpg;*.png;*.gif','Image Files (*.jpeg, *.jpg, *.png, *.gif)';'*.*','All Files (*.*)'},['Select the first ', original_or_test_1, ' image']);

if isequal(filename1,0)
    disp('User selected Cancel');
    return;
else
    disp(['User selected ', fullfile(pathname1, filename1)]);
end

% Ask the user to select the original or test image for the second image
answer2 = questdlg('Which image are you selecting for the second image?', ...
    'Image Selection', ...
    'Original','Test','Cancel','Original');

switch answer2
    case 'Original'
        original_or_test_2 = 'Original';
    case 'Test'
        original_or_test_2 = 'Test';
    case 'Cancel'
        disp('User selected Cancel');
        return;
end

% Let the user choose the second image
[filename2, pathname2] = uigetfile({'*.jpeg;*.jpg;*.png;*.gif','Image Files (*.jpeg, *.jpg, *.png, *.gif)';'*.*','All Files (*.*)'},['Select the second ', original_or_test_2, ' image']);

if isequal(filename2,0)
    disp('User selected Cancel');
    return;
else
    disp(['User selected ', fullfile(pathname2, filename2)]);
end

% Read the images
I1 = rgb2gray(imread(fullfile(pathname1, filename1)));
I2 = rgb2gray(imread(fullfile(pathname2, filename2)));

% Display the images
subplot(2,1,1)
imshow(I1)
subplot(2,1,2);
imshow(I2)

% Detect Harris features
points1 = detectHarrisFeatures(I1);
points2 = detectHarrisFeatures(I2);

% Extract features
[features1, valid_points1] = extractFeatures(I1, points1);
[features2, valid_points2] = extractFeatures(I2, points2);

% Match features
indexPairs = matchFeatures(features1, features2);

% Get matched points
matchedPoints1 = valid_points1(indexPairs(:,1),:);
matchedPoints2 = valid_points2(indexPairs(:,2),:);

% Calculate metric difference
u = matchedPoints2.Metric - matchedPoints1.Metric;

% Check if matched
if all(abs(u) <= 0.1)
    msgbox('Images are matched','Matched','modal');
else
    msgbox('Images are not matched','Not Matched','warn','modal');
end
