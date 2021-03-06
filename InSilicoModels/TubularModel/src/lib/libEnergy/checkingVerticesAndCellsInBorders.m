function [borderCells,arrayValidVerticesBorderLeft,arrayValidVerticesBorderRight]=checkingVerticesAndCellsInBorders(L_img,vertices)
%CHECKINGVERTICESANDCELLSINBORDERS label the vertices of border cells two
%know how join the vertices for knowing the edge length. This function
%minimize the presence of outlayer.
    borderCells=unique([L_img(:,1);L_img(:,end)]);
    borderCells=borderCells(borderCells~=0)';

    [~,W]=size(L_img);
    
    arrayProjectionCellVertices=vertices(:).verticesConnectCells;
    
    %defining valid vertices in valid left border cell
    arrayValidVerticesBorderLeft=zeros(size(vertices.verticesPerCell,1),1);
    arrayValidVerticesBorderRight=zeros(size(vertices.verticesPerCell,1),1);
           
    
    for nCell = borderCells
        
        [indexes,~]=find(arrayProjectionCellVertices==nCell);
        if ~isempty(indexes)
            indexes=sort(indexes);

            V=vertcat(vertices.verticesPerCell{indexes,1});
%             V=unique(V,'rows','stable');
            V(V(:,2)>W,2)=W;
            V=round(V);

            [~,~,V1index,V2index]=checkVerticesBorder(nCell,L_img,V,W);
            arrayValidVerticesBorderLeft(indexes(V1index))=1;
            arrayValidVerticesBorderRight(indexes(V2index))=1;
        end
    end

end
