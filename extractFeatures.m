function features = extractFeatures(preprocessedImage)
    % Edge detection using Sobel operator
    edgeMap = edge(preprocessedImage, 'sobel');

    % Create a composite structuring element that combines multiple dilations
    seComposite = strel('rectangle', [3, 12]);  % This is a simplification to combine the two line dilations
    dilatedImage = imdilate(edgeMap, seComposite);

    % Fill holes to make the features more continuous
    filledImage = imfill(dilatedImage, 'holes');

    % Erosion followed by dilation (opening) to smooth edges and reduce noise
    seDiamond = strel('diamond', 1);
    smoothedImage = imerode(filledImage, seDiamond);

    % Closing to connect nearby edges using a disk that provides isotropic processing
    seDisk = strel('disk', 1);
    connectedFeatures = imclose(smoothedImage, seDisk);

    features = connectedFeatures;

    return;
end
