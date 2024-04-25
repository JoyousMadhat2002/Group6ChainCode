function plotChainCode(app, chainCode)
    axes(app.UIAxes_3);
    numSteps = length(chainCode);
    xs = zeros(1, numSteps + 1);
    ys = zeros(1, numSteps + 1);
    colors = lines(8);  % Generate 8 distinct colors

    x = 0;
    y = 0;
    hold(app.UIAxes_3, 'on');  % Hold on to plot multiple lines

    for i = 1:numSteps
        switch chainCode(i)
            case 0
                x = x + 1; % Right
            case 1
                x = x + 1; y = y - 1; % Right-Down
            case 2
                y = y - 1; % Down
            case 3
                x = x - 1; y = y - 1; % Left-Down
            case 4
                x = x - 1; % Left
            case 5
                x = x - 1; y = y + 1; % Left-Up
            case 6
                y = y + 1; % Up
            case 7
                x = x + 1; y = y + 1; % Right-Up
        end
        xs(i + 1) = x;
        ys(i + 1) = y;
        plot(app.UIAxes_3, xs(i:i+1), ys(i:i+1), '-o', 'Color', colors(chainCode(i)+1, :));
    end

    hold(app.UIAxes_3, 'off');  % Release hold after plotting
    axis(app.UIAxes_3, 'equal');
    title(app.UIAxes_3, 'Chain Code Visualization');
end
