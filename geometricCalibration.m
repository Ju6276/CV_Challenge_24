function rectangle = geometricCalibration(input_image, corners, outH, outW)
    pLT = corners(1, :);
    pRT = corners(2, :);
    pRB = corners(3, :);
    pLB = corners(4, :);

    vector1 = pLB - pLT;
    vector2 = pRT - pLT;
    vector3 = pRB - pLT;

    A = [vector1', vector2'];
    B = vector3';
    S = A\B;
    a0 = S(1);
    a1 = S(2);

    rectangle = uint8(zeros(outH, outW, size(input_image, 3)));
    for i = 1:outH
        for j = 1:outW
            x0 = i / outH;
            x1 = j / outW;
            denom = a0 + a1 - 1 + (1 - a1) * x0 + (1 - a0) * x1;
            y0 = a0 * x0 / denom;
            y1 = a1 * x1 / denom;

            OriCoord = y0 * vector1 + y1 * vector2 + pLT;
            heightC = min(max(round(OriCoord(2)), 1), size(input_image, 1));
            widthC = min(max(round(OriCoord(1)), 1), size(input_image, 2));

            rectangle(i, j, :) = input_image(heightC, widthC, :);
        end
    end
end
