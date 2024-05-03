function chainCode = generateChainCode(features)
    % Find boundaries of all connected components
    boundaries = bwboundaries(features, 'noholes');

    if isempty(boundaries)
        chainCode = [];
        return;
    end

    boundary = boundaries{1};
    numPoints = size(boundary, 1);

    % Initialize the lookup table for direction vectors
    keys = 0:7;
    values = {
        [1, 0],                           % East
        [sqrt(2)/2, -sqrt(2)/2],          % Northeast
        [0, -1],                          % North
        [-sqrt(2)/2, -sqrt(2)/2],         % Northwest
        [-1, 0],                          % West
        [-sqrt(2)/2, sqrt(2)/2],          % Southwest
        [0, 1],                           % South
        [sqrt(2)/2, sqrt(2)/2]            % Southeast
    };
    directionMap = containers.Map(keys, values);

    % Initialize chain code storage and variables for previous state
    chainCode = [];
    previousDirection = -1;
    previousPoint = boundary(1, :);  % Start with the first point

    % Loop over each point in the boundary
    for k = 2:numPoints
        currentPoint = boundary(k, :);
        directionVector = currentPoint - previousPoint;

        % Skip zero vectors which may be noise
        if norm(directionVector) == 0
            continue;
        end

        % Normalize the direction vector
        directionVector = directionVector / norm(directionVector);

        % Find the direction in the map
        code = -1;
        for key = keys
            directionVal = directionMap(key);
            if all(abs(directionVector - directionVal) < 1e-10)
                code = key;
                break;
            end
        end

        if code == -1
            disp(['Unhandled direction: ', num2str(directionVector)]);
            continue;
        end

        % Store the first valid code or when there's a change in direction
        if previousDirection == -1 || previousDirection ~= code
            chainCode(end+1) = code;
        end

        % Update previous direction and point for next comparison
        previousDirection = code;
        previousPoint = currentPoint;
    end

    % Reduce chain code length by removing consecutive duplicates
    chainCode = uniqueConsecutive(chainCode);

    % Sort the chain code in ascending order
    chainCode = sort(chainCode);
    
    % Additional check to ensure output is within the expected length
    if length(chainCode) > 8
        chainCode = chainCode(1:8);
    end
end

function output = uniqueConsecutive(vec)
    output = vec(1);
    for i = 2:length(vec)
        if vec(i) ~= vec(i-1)
            output(end+1) = vec(i);
        end
    end
end
