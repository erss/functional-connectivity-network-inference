function [ patient_coordinates ] = load_pc_scc(source_session)
% Creates patient_coordinates structure.  If doesn't exist already, creates
% using all files, if already exists in folder, loads information
%
% INPUTS:
%   DATAPATH      = Path to directory of patient,
%                   example: '~/Desktop/bects_data/pBECTS001'
%  source_session = Name of file containing coordinate information.
%
% OUTPUT:
%  patient_coordinates is a structure containing fields:
%
%  name   = patient name
%
%  coords = [5 x 324] First row contains 1 = left hemisphere, 2 = right
%  hemisphere; Second row contains vertex indices; Third - Fifth rows
%  contain xyz coordinates
%
%  LDL, RDL = Desikan labels of each vertex (Left and right hemispheres
%  respectively)
%
%  left_focus, right_focus = Vertex indices for the seizure onset zone in
%  the left and right hemispheres respectively.
%
%ç
%  Questions: (1) do I include hand, spiking hemisphere, status ...?
%             (2) xyz are the same for each sesssion
if strcmp(source_session(11:16),'visit2')
    patient_name = source_session(1:16);
else
    patient_name = source_session(1:9);
end


if exist([ '/projectnb/ecog/BECTS/source_data_ds/' patient_name '/patient_coordinates.mat'],'file') ~=2
    load(['/projectnb/ecog/BECTS/npdata.mat']);
    load(['/projectnb/ecog/BECTS/source_data/' patient_name '/' patient_name '_source_in_lowerhalf']);
    load(['/projectnb/ecog/BECTS/source_data/' patient_name '/sleep_source/' source_session]);
    load(['/projectnb/ecog/BECTS/ESI-Liz_Desikan-labels/' patient_name '_sourcespace_desikan_labels']);
    
    patient_coordinates.name   = patient_name;
    patient_coordinates.coords = [[ones(1,162); left_desikan_vertexIco2'; ...
        ico_2_source_points_coordinates_left(:,2:4)'], ...
        [2*ones(1,162); right_desikan_vertexIco2'; ...
        ico_2_source_points_coordinates_right(:,2:4)']];
    patient_coordinates.LDL    = left_desikan_label;
    patient_coordinates.RDL    = right_desikan_label;
    
    patient_coordinates.left_focus  = [source_in_left_pos source_in_left_pre];
    patient_coordinates.right_focus = [source_in_right_pos source_in_right_pre];
    
    %%% ------ REMOVE LABELS THAT ARE NOT PRECENTRAL OR POSTCENTRAL----
    xyz= patient_coordinates.coords;
    LN = zeros(1,length(patient_coordinates.left_focus));
    RN = zeros(1,length(patient_coordinates.right_focus));
    for i = 1:length(patient_coordinates.left_focus)
        if length(find(xyz(2,:)==patient_coordinates.left_focus(i))) ==2
            temp = find(xyz(2,:)==patient_coordinates.left_focus(i));
            LN(i) =temp(1);
        elseif length(find(xyz(2,:)==patient_coordinates.left_focus(i))) ==1
            LN(i) = find(xyz(2,:)==patient_coordinates.left_focus(i));
        end
        
    end
    
    for i = 1:length(patient_coordinates.right_focus)
        
        if length(find(xyz(2,:)==patient_coordinates.right_focus(i))) ==2
            temp = find(xyz(2,:)==patient_coordinates.right_focus(i));
            RN(i) =temp(2);
        elseif length(find(xyz(2,:)==patient_coordinates.right_focus(i))) ==1
            RN(i) = find(xyz(2,:)==patient_coordinates.right_focus(i));
        end
    end
    
    RN = RN-162;
    %         patient_coordinates.LDL(LN)
    %         patient_coordinates.RDL(RN)
    iPre =strcmp(patient_coordinates.LDL(LN),'precentral');
    iPost =strcmp(patient_coordinates.LDL(LN),'postcentral');
    iL = iPre+iPost;
    
    iPre =strcmp(patient_coordinates.RDL(RN),'precentral');
    iPost =strcmp(patient_coordinates.RDL(RN),'postcentral');
    iR = iPre+iPost;
    
    iL=logical(iL);
    iR=logical(iR);
    patient_coordinates.left_focus_rm = patient_coordinates.left_focus(~iL);
    patient_coordinates.right_focus_rm = patient_coordinates.right_focus(~iR);
    patient_coordinates.left_focus=patient_coordinates.left_focus(iL);
    patient_coordinates.right_focus=patient_coordinates.right_focus(iR);
    %%% ---------------------------------------------------------------
    
    
    i = find(strcmp(npdata.ID,patient_name));
    patient_coordinates.hand   = char(npdata.Handedness(i));
    patient_coordinates.status = char(npdata.Group(i));
    patient_coordinates.gender = char(npdata.Sex(i));
    patient_coordinates.age = npdata.Age(i);
    save(['/projectnb/ecog/BECTS/source_data_ds/' patient_name '/patient_coordinates.mat'],'patient_coordinates')
    
    
    
    
else
    load(['/projectnb/ecog/BECTS/source_data_ds/' patient_name '/patient_coordinates.mat']);
end

end

