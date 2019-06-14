function ds = extract_data_from_roi(data,roi)
% EXTRACT_DATA_FROM_ROI Compute mean, min, and max of data at
% region-of-interest
%
% SYNTAX
% ds = EXTRACT_DATA_FROM_ROI(data,roi)
%
% DESCRIPTION
% Uses SPM functions to extract image data from ROI images. Assumes (and
% asserts) that data and ROI images have identical dimensions and
% transformation matrices. Also assumes (and asserts) that ROI images are
% masks, meaning that they contain only 0s and 1s.
%
% INPUTS
% data              - char array of file paths to data NIfTI images
% roi               - char array of file paths to ROI NIfTI images
%
% .........................................................................
% Bram Zandbelt, bramzandbelt@gmail.com

%  Get header information for images
Vdata = spm_vol(data);
Vroi = spm_vol(roi);

nData   = numel(Vdata);
Nroi   = numel(Vroi);
levels  = fullfact([nData,Nroi]);
nRow    = nData * Nroi;


% Create a DataSet array
ds = dataset({levels(:,1),'iData'}, ...
             {levels(:,2),'iRoi'}, ...
             {cell(nRow,1),'dataFilePath'}, ...
             {cell(nRow,1),'roiFilePath'}, ...
             {cell(nRow,1),'dataFileName'}, ...
             {cell(nRow,1),'roiFileName'}, ...
             {nan(nRow,1),'roiSize'}, ... % in voxels
             {nan(nRow,1),'meanRoiContrastEstimate'}, ... 
             {nan(nRow,1),'minRoiContrastEstimate'}, ... 
             {nan(nRow,1),'maxRoiContrastEstimate'});
     
% Read in image volumes
[Ydata,XYZdata] = spm_read_vols(Vdata);
[Yroi,XYZroi] = spm_read_vols(Vroi);

% Determine size of each ROI (in number of voxels)
roiSize = nan(Nroi,1);
for iRoi = 1:Nroi
    thisRoi        = Yroi(:,:,:,iRoi);    
%     assert(all(unique(thisRoi) == [0 1]'),sprintf('The following image contains values other than 0s and 1s: \n %s',Vroi(iRoi).fname))
    roiSize(iRoi)  = numel(find(thisRoi));
end

% Loop over data
for iData = 1:nData
    for iRoi = 1:Nroi
        
        % Assert idential dimensions and transformation matrix for mask and data
        assert(all(Vroi(iRoi).dim == Vdata(iData).dim), ...
               sprintf('Dimensions of following images do not match: \n %s \n %s',Vroi(iRoi).fname,Vdata(iData).fname));
        assert(all(all(Vroi(iRoi).mat == Vdata(iData).mat)), ...
               sprintf('Transformation matrices of following images do not match: \n %s \n %s',Vroi(iRoi).fname,Vdata(iData).fname));
        
        % Identify dataset row corresponding to this data and mask
        iRow    =  find((ds.iData == iData) & (ds.iRoi == iRoi));
        
        % Log data and mask file paths and file names
        [ds.dataFilePath{iRow},ds.dataFileName{iRow}]   = fileparts(Vdata(iData).fname);
        [ds.roiFilePath{iRow},ds.roiFileName{iRow}]     = fileparts(Vroi(iRoi).fname);
        
        % Isolate data and roi
        thisData = Ydata(:,:,:,iData);
        thisRoi = Yroi(:,:,:,iRoi);
        
        % Log ROI size
        ds.roiSize(iRow) = roiSize(iRoi);
        
        % Extract mean data value in mask area
        ds.meanRoiContrastEstimate(iRow)    = nanmean(thisData(find(thisRoi)));
        ds.minRoiContrastEstimate(iRow)     = min(thisData(find(thisRoi)));
        ds.maxRoiContrastEstimate(iRow)     = max(thisData(find(thisRoi)));
        
    end
end

