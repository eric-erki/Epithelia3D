
numSeeds=400;
numOfSurfaceRatios=10;
numberOfHistogramsCells=11;
nameOfFolder=['512x1024_' num2str(numSeeds) 'seeds\'];
path3dVoronoi='D:\Pedro\Epithelia3D\Salivary Glands\Curvature model\data\expansion\512x1024_400seeds\';
directory2save='..\..\data\expansion\512x1024_400seeds\';
addpath('lib')   
pathV5data=dir([path3dVoronoi '*m_5*']);

listTransitionPerCell=zeros(numberOfHistogramsCells,numOfSurfaceRatios,size(pathV5data,1));
listWinningNeigh=zeros(numberOfHistogramsCells,numOfSurfaceRatios,size(pathV5data,1));
listLossingNeigh=zeros(numberOfHistogramsCells,numOfSurfaceRatios,size(pathV5data,1));
listNumberOfCellsWinning=zeros(numOfSurfaceRatios,size(pathV5data,1));
listNumberOfCellsLossing=zeros(numOfSurfaceRatios,size(pathV5data,1));
listNumberOfCellsLossingOrWinning=zeros(numOfSurfaceRatios,size(pathV5data,1));
listNumberOfCellsInNoTransitions=zeros(numOfSurfaceRatios,size(pathV5data,1));

for i=1:size(pathV5data,1)

    %load cylindrical Voronoi 5 data
    load([path3dVoronoi pathV5data(i).name '\' pathV5data(i).name '.mat'],'listLOriginalProjection')

    numberOfCellsWinning=zeros(1,size(listLOriginalProjection,1));
    numberOfCellsLossing=zeros(1,size(listLOriginalProjection,1));
    numberOfCellsLossingOrWinning=zeros(1,size(listLOriginalProjection,1));
    numberOfCellsInNoTransitions=zeros(1,size(listLOriginalProjection,1));
    winningNeigh=zeros(size(listLOriginalProjection,1),numberOfHistogramsCells);
    lossingNeigh=zeros(size(listLOriginalProjection,1),numberOfHistogramsCells);
    transitionPerCell=zeros(size(listLOriginalProjection,1),numberOfHistogramsCells);
    
    for j=1:size(listLOriginalProjection,1)
        L_basal=listLOriginalProjection.L_originalProjection{1,1};
        L_apical=listLOriginalProjection.L_originalProjection{j,1};
        %calculate neighbourings in apical and basal layers
        [neighs_basal,~]=calculate_neighbours(L_basal);
        [neighs_apical,~]=calculate_neighbours(L_apical);

        %get happening per cell
        Lossing=cellfun(@(x,y) setdiff(x,y),neighs_basal,neighs_apical,'UniformOutput',false);
        Winning=cellfun(@(x,y) setdiff(x,y),neighs_apical,neighs_basal,'UniformOutput',false);

        winningPerCell=cell2mat(cellfun(@(x) length(x),Winning,'UniformOutput',false));
        lossingPerCell=cell2mat(cellfun(@(x) length(x),Lossing,'UniformOutput',false));
        motifsTransitionPerCell=cell2mat(cellfun(@(x,y) length(unique([x; y])),Lossing,Winning,'UniformOutput',false));

        %number of presences
        numberOfCellsWinning(1,j)=sum(winningPerCell>0);
        numberOfCellsLossing(1,j)=sum(lossingPerCell>0);
        numberOfCellsLossingOrWinning(1,j)=sum(motifsTransitionPerCell>0);
        numberOfCellsInNoTransitions(1,j)=max(max(L_basal))-numberOfCellsLossingOrWinning(1,j);

        %Data for histograms
        winningNeigh(j,:)=[sum(winningPerCell==0),sum(winningPerCell==1),sum(winningPerCell==2),sum(winningPerCell==3),sum(winningPerCell==4)...
            sum(winningPerCell==5),sum(winningPerCell==6),sum(winningPerCell==7),sum(winningPerCell==8),sum(winningPerCell==9),sum(winningPerCell==10)];
        lossingNeigh(j,:)=[sum(lossingPerCell==0),sum(lossingPerCell==1),sum(lossingPerCell==2),sum(lossingPerCell==3),sum(lossingPerCell==4)...
            sum(lossingPerCell==5),sum(lossingPerCell==6),sum(lossingPerCell==7),sum(lossingPerCell==8),sum(lossingPerCell==9),sum(lossingPerCell==10)];
        transitionPerCell(j,:)=[sum(motifsTransitionPerCell==0),sum(motifsTransitionPerCell==1),sum(motifsTransitionPerCell==2),sum(motifsTransitionPerCell==3),sum(motifsTransitionPerCell==4)...
            sum(motifsTransitionPerCell==5),sum(motifsTransitionPerCell==6),sum(motifsTransitionPerCell==7),sum(motifsTransitionPerCell==8),sum(motifsTransitionPerCell==9),sum(motifsTransitionPerCell==10)];
           
        
        
    end
        %Acum data
        listTransitionPerCell(:,:,i)=transitionPerCell';
        listWinningNeigh(:,:,i)=winningNeigh';
        listLossingNeigh(:,:,i)=lossingNeigh';
        listNumberOfCellsWinning(:,i)=numberOfCellsWinning';
        listNumberOfCellsLossing(:,i)=numberOfCellsLossing';
        listNumberOfCellsLossingOrWinning(:,i)=numberOfCellsLossingOrWinning';
        listNumberOfCellsInNoTransitions(:,i)=numberOfCellsInNoTransitions';
end


%averages and std of total data

finalListTransitionPerCell.average=mean(listTransitionPerCell,3);
finalListTransitionPerCell.standardDeviation=std(listTransitionPerCell,[],3);
finalListWinningNeigh.average=mean(listWinningNeigh,3);
finalListWinningNeigh.standardDeviation=std(listWinningNeigh,[],3);
finalListLossingNeigh.average=mean(listLossingNeigh,3);
finalListLossingNeigh.standardDeviation=std(listLossingNeigh,[],3);
finalListNumberOfCellsWinning.average=mean(listNumberOfCellsWinning,2);
finalListNumberOfCellsWinning.standardDeviation=std(listNumberOfCellsWinning,[],2);
finalListNumberOfCellsLossing.average=mean(listNumberOfCellsLossing,2);
finalListNumberOfCellsLossing.standardDeviation=std(listNumberOfCellsLossing,[],2);
finalListNumberOfCellsLossingOrWinning.average=mean(listNumberOfCellsLossingOrWinning,2);
finalListNumberOfCellsLossingOrWinning.standardDeviation=std(listNumberOfCellsLossingOrWinning,[],2);
finalListNumberOfCellsInNoTransitions.average=mean(listNumberOfCellsInNoTransitions,2);
finalListNumberOfCellsInNoTransitions.standardDeviation=std(listNumberOfCellsInNoTransitions,[],2);

save([directory2save 'dataCellsInTransitionMotifs.mat'],'finalListTransitionPerCell','finalListWinningNeigh','finalListLossingNeigh','finalListNumberOfCellsWinning','finalListNumberOfCellsLossing','finalListNumberOfCellsLossingOrWinning','finalListNumberOfCellsInNoTransitions')
