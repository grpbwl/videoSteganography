function [ sequence ] = extractYuv( yuvPath , a, b, type)
%EXTRACTSEQUENCE Extracts a specific region of the yuvVideo
%   Extract a sequence of frames from the YUV video starting from a to b.
%   The type of the sequence must be specified, it must either be 'cif' or
%   'qcif'.

% Load format sizes
load('format');
sequenceSize = [0 0];

% Checking which size to use, if invalid argument given, bail.
if strcmp('qcif',type)
    sequenceSize = format.qcif;
elseif strcmp('cif', type)
    sequenceSize = format.cif;
else
    error('Invalid value for ''type'', valid options are ''cif'' and ''qcif''');
end

% Ensuring correct range.
if a > b
    error('Invalid range: a must be less than b.');
end

sequence = repmat(struct('cdata',uint8(zeros(sequenceSize(2),sequenceSize(1),3)),'colormap',cell(1)),1,(b-a));

% Traverse the video sequence extracting all the frames and storing them
for frame=1:abs(b-a)+1
    temp = loadFileYuv(yuvPath,sequenceSize(1),sequenceSize(2),frame);
    sequence(frame).cdata = temp.cdata;
end

end

