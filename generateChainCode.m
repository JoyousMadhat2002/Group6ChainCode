function chainCode = generateChainCode(features)
    % Find boundaries of all connected components
    boundaries = bwboundaries(features);

    % Check if any boundaries were found
    if isempty(boundaries)
        chainCode = [];
        return;
    end

    % Use the largest boundary for simplicity
    boundary = boundaries{1};
    numPoints = size(boundary, 1);

    % Preallocate the chain code array
    chainCode = zeros(1, numPoints - 1);  % -1 because the differential will be calculated from the second point

    % Previous direction initialization
    previousPoint = boundary(1, :);
    previousDirection = -1;  % Initialize with a non-directional value

    % Loop over each point in the boundary starting from the second point
     for k = 2:numPoints
        currentPoint = boundary(k, :);
        direction = currentPoint - previousPoint;
        code = -1;
        
        % Determine the direction code
        if direction(1) == 1 && direction(2) == 0
            code = 0;
        elseif direction(1) == 1 && direction(2) == -1
            code = 1;
        elseif direction(1) == 0 && direction(2) == -1
            code = 2;
        elseif direction(1) == -1 && direction(2) == -1
            code = 3;
        elseif direction(1) == -1 && direction(2) == 0
            code = 4;
        elseif direction(1) == -1 && direction(2) == 1
            code = 5;
        elseif direction(1) == 0 && direction(2) == 1
            code = 6;
        elseif direction(1) == 1 && direction(2) == 1
            code = 7;
        end

        % Skip if direction is undefined
        if code == -1
            continue;
        end

        % Calculate differential code starting from the second point
        if k > 2 && previousDirection ~= -1
            diffCode = mod(code - previousDirection + 4, 4);
            chainCode(k-2) = diffCode;  % Store the differential code
        elseif k == 2  % The very first direction
            chainCode(1) = code;
        end

        % Update previous direction and point
        previousDirection = code;
        previousPoint = currentPoint;
     end
           % Normalization: Rotate chain code to start with the smallest number
    [~, idx] = min(chainCode);
    chainCode = [chainCode(idx:end), chainCode(1:idx-1)];
end
