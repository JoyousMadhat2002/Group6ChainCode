% Read the image
originalImage = imread('doublered.png'); % Replace 'your_image.jpg' with the filename of your image

% Convert the image to grayscale if it's RGB
if size(originalImage, 3) == 3
    grayImage = rgb2gray(originalImage);
else
    grayImage = originalImage;
end

% Detect edges using the Canny method
edgeImage = edge(grayImage, 'Canny');

% Perform morphological thinning to ensure one-pixel-wide boundary
thinnedEdgeImage = bwmorph(edgeImage, 'thin', Inf);

% Display the edge image
figure;
imshow(edgeImage);
title('Edge Image');

% Display the thinned edge image
figure;
imshow(thinnedEdgeImage);
title('Thinned Edge Image');

% Find boundary pixels and chain code
[chainCodeImage, chainCode] = traverseBoundaryWithCodes(thinnedEdgeImage);

% Display the chain code
disp('Chain Code:');
disp(num2str(chainCode));

function [chainCodeImage, chainCode] = traverseBoundaryWithCodes(thinnedEdgeImage)
    % Find the starting pixel (P0)
    [row, col] = find(thinnedEdgeImage, 1, 'first');
    startingPixel = [row, col];
    currentPixel = startingPixel;
    
    % Initialize direction
    DIR = 7;
    
    % Define directions
    directions = [0, -1; -1, -1; -1, 0; -1, 1; 0, 1; 1, 1; 1, 0; 1, -1];
    codeValues = [4, 3, 2, 1, 0, 5, 6, 7]; % Corresponding values for directions
    
    % Initialize chain code image
    chainCodeImage = zeros(size(thinnedEdgeImage));
    
    % Traverse the boundary
    chainCode = [];
    while true
        % Find the direction of the next white pixel
        nextDir = mod(DIR + 7, 8);
        found = false;
        for i = 1:8
            nextPixel = currentPixel + directions(nextDir + 1, :);
            if thinnedEdgeImage(nextPixel(1), nextPixel(2))
                found = true;
                break;
            else
                nextDir = mod(nextDir + 1, 8);
            end
        end
        
        % Break if the starting pixel is reached again
        if isequal(nextPixel, startingPixel)
            break;
        end
        
        % Assign the code value
        chainCodeImage(currentPixel(1), currentPixel(2)) = codeValues(nextDir + 1);
        chainCode = [chainCode, codeValues(nextDir + 1)];
        
        % Move to the next pixel
        currentPixel = nextPixel;
        DIR = nextDir;
    end
    
    % Assign the code value for the starting pixel
    chainCodeImage(currentPixel(1), currentPixel(2)) = codeValues(mod(DIR + 1, 8) + 1);
    chainCode = [chainCode, codeValues(mod(DIR + 1, 8) + 1)];
end

