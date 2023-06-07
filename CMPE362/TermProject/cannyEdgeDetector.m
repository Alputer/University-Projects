function edgeImage = cannyEdgeDetector(image, sigma, lowThreshold, highThreshold)

    % Step 1: Convert the image to grayscale
    grayImage = rgb2gray(image);

    % Step 2: Apply Gaussian smoothing to reduce noise
    filteredImage = imgaussfilt(grayImage, sigma);

    % Step 3: Compute gradients using Sobel operators
    
    sobelX = [-1 0 1; -2 0 2; -1 0 1];
    sobelY = [-1 -2 -1; 0 0 0; 1 2 1];
    gradientX = imfilter(filteredImage, sobelX);
    gradientY = imfilter(filteredImage, sobelY);
    gradientX = double(gradientX);
    gradientY = double(gradientY);
    
    % Step 4: Compute gradient magnitude and orientation
    
    gradientMagnitude = hypot(gradientX, gradientY);
    gradientOrientation = atan2(gradientY, gradientX);
    
    % Step 5: Non-maximum suppression
    suppressedImage = nonMaxSuppression(gradientMagnitude, gradientOrientation);
    
    % Step 6: Double thresholding
    thresholdedImage = doubleThresholding(suppressedImage, lowThreshold, highThreshold);
    
    % Step 7: Edge tracking by hysteresis
    edgeImage = edgeTrackingByHysteresis(thresholdedImage);

end

function suppressedImage = nonMaxSuppression(gradientMagnitude, gradientOrientation)
    [rows, cols] = size(gradientMagnitude);
    suppressedImage = zeros(rows, cols);
    
    % Convert orientation values to angles between 0 and 180 degrees
    angle = rad2deg(gradientOrientation);
    angle(angle < 0) = angle(angle < 0) + 180;
    
    % Perform non-maximum suppression
    for i = 2:rows-1
        for j = 2:cols-1
            q = 255;
            r = 255;
            
            % Find the appropriate neighboring pixels based on the orientation
            if (0 <= angle(i,j) && angle(i,j) < 22.5) || (157.5 <= angle(i,j) && angle(i,j) <= 180)
                q = gradientMagnitude(i, j + 1);
                r = gradientMagnitude(i, j - 1);
            elseif 22.5 <= angle(i,j) && angle(i,j) < 67.5
                q = gradientMagnitude(i + 1, j - 1);
                r = gradientMagnitude(i - 1, j + 1);
            elseif 67.5 <= angle(i,j) && angle(i,j) < 112.5
                q = gradientMagnitude(i + 1, j);
                r = gradientMagnitude(i - 1, j);
            elseif 112.5 <= angle(i,j) && angle(i,j) < 157.5
                q = gradientMagnitude(i - 1, j - 1);
                r = gradientMagnitude(i + 1, j + 1);
            end
            
            % Perform suppression
            if gradientMagnitude(i,j) >= q && gradientMagnitude(i,j) >= r
                suppressedImage(i,j) = gradientMagnitude(i,j);
            else
                suppressedImage(i,j) = 0;
            end
        end
    end
end

function thresholdedImage = doubleThresholding(suppressedImage, lowThreshold, highThreshold)
    [rows, cols] = size(suppressedImage);
    thresholdedImage = zeros(rows, cols);
    
    % Perform thresholding
    thresholdedImage(suppressedImage >= highThreshold) = 1;
    
    % Apply hysteresis thresholding
    visited = zeros(rows, cols);
    stack = [];
    
    % Find strong edges and start the edge tracking process
    [strongRows, strongCols] = find(suppressedImage >= highThreshold);
    numStrong = numel(strongRows);

    for i = 1:numStrong
        if visited(strongRows(i), strongCols(i)) == 0
            stack = [stack; strongRows(i), strongCols(i)];
            visited(strongRows(i), strongCols(i)) = 1;
        end
    end
    
    % Perform edge tracking
    while ~isempty(stack)
        currentPixel = stack(1, :);
        stack(1, :) = [];
        neighbors = getNeighbors(currentPixel(1), currentPixel(2), rows, cols);
        
        for k = 1:size(neighbors, 1)
            row = neighbors(k, 1);
            col = neighbors(k, 2);
            
            if visited(row, col) == 0 && suppressedImage(row, col) >= lowThreshold
                stack = [stack; row, col];
                visited(row, col) = 1;
                thresholdedImage(row, col) = 1;
            end
        end
    end
end

function edgeImage = edgeTrackingByHysteresis(thresholdedImage)
    [rows, cols] = size(thresholdedImage);
    edgeImage = zeros(rows, cols);
  
    
    % Perform edge tracking by hysteresis
    for i = 2:rows-1
        for j = 2:cols-1
            if thresholdedImage(i, j) == 1 && edgeImage(i, j) == 0
                edgeImage(i, j) = 1;
                
                % Perform depth-first search to find connected edges
                stack = [i, j];
                while ~isempty(stack)
                    currentPixel = stack(1, :);
                    stack(1, :) = [];
                    
                    % Get neighbors of current pixel
                    neighbors = getNeighbors(currentPixel(1), currentPixel(2), rows, cols);
                    
                    for k = 1:size(neighbors, 1)
                        row = neighbors(k, 1);
                        col = neighbors(k, 2);
                        
                        % Check if neighbor is a candidate edge
                        if thresholdedImage(row, col) == 1 && edgeImage(row, col) == 0
                            edgeImage(row, col) = 1;
                            stack = [stack; row, col];
                        end
                    end
                end
            end
        end
    end
end

function neighbors = getNeighbors(row, col, numRows, numCols)
    neighbors = [row-1, col-1; row-1, col; row-1, col+1; row, col-1; row, col+1; row+1, col-1; row+1, col; row+1, col+1];
    
    % Remove neighbors that are out of bounds
    invalidRows = neighbors(:, 1) < 1 | neighbors(:, 1) > numRows;
    invalidCols = neighbors(:, 2) < 1 | neighbors(:, 2) > numCols;
    neighbors(invalidRows | invalidCols, :) = [];
end
