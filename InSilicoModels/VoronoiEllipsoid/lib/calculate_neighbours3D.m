function [ellipsoidInfo] = calculate_neighbours3D(L_img, ellipsoidInfo)

%% Generate neighbours
    ratio=4;
    neighs_real={};
    cells=sort(unique(L_img));
    cells=cells(cells~=0);                  %% Deleting cell 0 from range

    [xgrid, ygrid, zgrid] = meshgrid(-ratio:ratio); 
    ball = (sqrt(xgrid.^2 + ygrid.^2 + zgrid.^2) <= ratio);
    
    imgPerim = bwperim(L_img) .* L_img;
    
    for cell = 1 : length(cells)
        BW_dilate = imdilate(imgPerim==cells(cell), ball);
        ellipsoidInfo.cellDilated{cell} = BW_dilate;
        neighs=unique(L_img(BW_dilate));
        neighs_real{cells(cell), 1} = neighs(neighs ~= 0 & neighs ~= cells(cell));
    end
    ellipsoidInfo.neighbourhood = neighs_real;
end

