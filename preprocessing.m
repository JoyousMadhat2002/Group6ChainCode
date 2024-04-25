function preprocessedImage = preprocessing(img)
    % Convert to grayscale to handle color images uniformly
    grayImg = im2gray(img);

    % Apply CLAHE to enhance local contrast and bring out more texture
    normalizedImg = adapthisteq(grayImg);

    % Analyze texture using GLCM at multiple scales
    offsets = [0 1; -1 1; -1 0; -1 -1; 0 2; -2 2; -2 0; -2 -2];  % Extended offsets for multi-scale analysis
    glcm = graycomatrix(normalizedImg, 'Offset', offsets, 'Symmetric', true);
    stats = graycoprops(glcm, {'Contrast', 'Homogeneity', 'Energy', 'Correlation'});

    % Dynamic thresholding based on the mean and standard deviation of GLCM properties
    meanHomogeneity = mean(stats.Homogeneity);
    stdHomogeneity = std(stats.Homogeneity);
    meanContrast = mean(stats.Contrast);
    meanEnergy = mean(stats.Energy);

    textureMask = (stats.Homogeneity > meanHomogeneity - stdHomogeneity) | ...
                  (stats.Contrast > meanContrast) | ...
                  (stats.Energy > meanEnergy);

    % Use the texture mask to isolate regions of interest
    preprocessedImage = normalizedImg;
    preprocessedImage(~textureMask) = 0;

    % Convert back to uint8 for further processing
    preprocessedImage = uint8(preprocessedImage);

    return;
end
