
dirData = dir('dog\\*.jpg');         %# Get the selected file data
fileNames = {dirData.name};     %# Create a cell array of file names
for iFile = 1:numel(fileNames)  %# Loop over the file names
  newName = sprintf('%d.jpg',iFile);  %# Make the new name
  
  movefile(sprintf('dog\\%s',fileNames{iFile}),sprintf('dog\\%s',newName));        %# Rename the file
end