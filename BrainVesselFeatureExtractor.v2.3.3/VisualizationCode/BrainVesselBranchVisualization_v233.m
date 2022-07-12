clear all
close all
clc

load('F:\MIPL\BrainVessel\BrainVesselFeatureExtractor.v2.2.1\sampels4update\0833_TOF_vessmask_704x704x270_reorient_isores=0.3551_2022Y7M1D22h22m48s\DataMat.mat')

figHandler = figure;
set(figHandler, 'KeyPressFcn', @bntDownFunc)

hold on

FV=isosurface(double(AirwayMask),0,'verbose');

FV.vertices(:,1) = FV.vertices(:,1)*vmtkSpacing(2) + vmtkOrigin(2);
FV.vertices(:,2) = FV.vertices(:,2)*vmtkSpacing(1) + vmtkOrigin(1);
FV.vertices(:,3) = FV.vertices(:,3)*vmtkSpacing(3) + vmtkOrigin(3);

temp = FV.vertices(:,1);
FV.vertices(:,1) = FV.vertices(:,2);
FV.vertices(:,2) = temp;

p = patch(FV);
whitebg('black')
set(p, 'FaceColor', 'Red', 'EdgeColor', 'none','faceAlpha',0.3);

%
axis tight
camlight
lighting gouraud
hold on
grid on
xlabel('X')
ylabel('Y')
zlabel('Z')
axis image
view(3)


currentAxix = axis;

axisWidth = currentAxix(2) - currentAxix(1);
axisCenter = mean([currentAxix(1) currentAxix(2)]);
newAxis(1) = axisCenter - axisWidth;
newAxis(2) = axisCenter + axisWidth;

axisWidth = currentAxix(4) - currentAxix(3);
axisCenter = mean([currentAxix(3) currentAxix(4)]);
newAxis(3) = axisCenter - axisWidth;
newAxis(4) = axisCenter + axisWidth;

axisWidth = currentAxix(6) - currentAxix(5);
axisCenter = mean([currentAxix(5) currentAxix(6)]);
newAxis(5) = axisCenter - axisWidth;
newAxis(6) = axisCenter + axisWidth;

axis(newAxis)

GroupIdList = unique(FinalCenterlineCoordsArray(:,5));
% Total branchs
% plot3(FinalCenterlineCoordsArray(:,1),FinalCenterlineCoordsArray(:,2),FinalCenterlineCoordsArray(:,3),'.')

% 1st brach
global groupId GroupPointsHandler TextHandler FinalCenterlineCoordsArray GroupIdList fontSize
fontSize = 10;
groupId = 1;
GroupPointList = FinalCenterlineCoordsArray(:,5) == GroupIdList(groupId);
GroupPointsHandler = plot3(FinalCenterlineCoordsArray(GroupPointList,1),FinalCenterlineCoordsArray(GroupPointList,2),FinalCenterlineCoordsArray(GroupPointList,3),'go');

GroupTextLoc = FinalCenterlineCoordsArray(round(median(find(GroupPointList))),1:3);
TextHandler = text(GroupTextLoc(1),GroupTextLoc(2),GroupTextLoc(3),num2str(groupId),'fontweight','bold', 'fontsize', fontSize);

plot3(StPoint(:,1),StPoint(:,2),StPoint(:,3),'ro')
plot3(EdPoint(:,1),EdPoint(:,2),EdPoint(:,3),'o')


GroupIdList = unique(FinalCenterlineCoordsArray(:,5));
newGroupIdList = zeros(size(GroupIdList));
i = 1;
while i <= length(GroupIdList)
    GroupPointList = FinalCenterlineCoordsArray(:,5) == GroupIdList(i);
    plot3(FinalCenterlineCoordsArray(GroupPointList,1),FinalCenterlineCoordsArray(GroupPointList,2),FinalCenterlineCoordsArray(GroupPointList,3),'.')

    GroupTextLoc = FinalCenterlineCoordsArray(round(median(find(GroupPointList))),1:3);
    %text(GroupTextLoc(1),GroupTextLoc(2),GroupTextLoc(3),num2str(i),'fontweight','bold')
    newGroupIdList(GroupPointList) = i;
    i = i + 1;
end



function groupId = bntDownFunc(src, event, groupId)
global groupId GroupPointsHandler TextHandler FinalCenterlineCoordsArray GroupIdList fontSize
if contains(event.Key, 'left') || contains(event.Key, 'right') || contains(event.Key, 'up') || contains(event.Key, 'down') 
    if contains(event.Key, 'left')
        if groupId == 1
            return
        end
        groupId = groupId - 1;
    elseif contains(event.Key, 'right')
        if groupId == length(GroupIdList)
            return
        end
        groupId = groupId + 1;
    elseif contains(event.Key, 'up')
        fontSize = fontSize + 1;
    elseif contains(event.Key, 'down')
        if fontSize > 1
            fontSize = fontSize - 1;
        end
    end
    delete(GroupPointsHandler)
    delete(TextHandler)
    
    disp(['Current Grupd ID: ', num2str(groupId)])
    
    GroupPointList = FinalCenterlineCoordsArray(:,5) == GroupIdList(groupId);
    GroupPointsHandler = plot3(FinalCenterlineCoordsArray(GroupPointList,1),FinalCenterlineCoordsArray(GroupPointList,2),FinalCenterlineCoordsArray(GroupPointList,3),'go');
    
    GroupTextLoc = FinalCenterlineCoordsArray(round(median(find(GroupPointList))),1:3);
    TextHandler = text(GroupTextLoc(1),GroupTextLoc(2),GroupTextLoc(3),num2str(groupId),'fontweight','bold','fontsize', fontSize);
end

end
