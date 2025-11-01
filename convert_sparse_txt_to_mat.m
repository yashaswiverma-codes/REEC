datasetName = 'WikipediaLarge-500K'; %change as per the dataset

filePath = '/home/data/xml/datasets/'; %modify 
fileName = [filePath datasetName '/' datasetName '_train.txt']; 

fid = fopen(fileName); 

firstLine = fgetl(fid); 
firstLine = strsplit(firstLine,' '); 

numOfSamples = str2num(firstLine{1}); 
numOfFeatures = str2num(firstLine{2}); 
numOfLabels = str2num(firstLine{3}); 

disp([num2str(numOfSamples) ' -- ' num2str(numOfFeatures) ' -- ' num2str(numOfLabels)]); 


allFeatures = []; 
allLabels = []; 
tic; 
for i = 1:numOfSamples 

        if( mod(i,1000)==0 ) 
                disp([datasetName ' -- ' num2str(i) ' -- ' num2str(numOfSamples)]); 
        end; 

        nextLine = fgetl(fid); 
        nextLine = strsplit(nextLine,' '); 

        currLabels = strsplit(nextLine{1},','); 
        lenCurrLabels = length(currLabels); 
        tempCurrLabels = sparse(zeros(1,numOfLabels)); 
        for j = 1:lenCurrLabels 
                tempCurrLabels(str2num(currLabels{j})+1) = 1; 
        end; 
        allLabels = [allLabels; tempCurrLabels]; 
        allLabels = sparse(allLabels); 
        
        lenNextLine = length(nextLine); 
        tempCurrFeatures = sparse(zeros(1,numOfFeatures)); 
        for j = 2:lenNextLine 
                ftrIndxVal = strsplit(nextLine{j},':'); 
                tempCurrFeatures(str2num(ftrIndxVal{1})+1) = str2num(ftrIndxVal{2}); 
        end; 
        allFeatures = sparse([allFeatures; tempCurrFeatures]); 
        %allFeatures = sparse(allFeatures); 
        
end; 
readTime = toc; 

fclose(fid); 

clear tempCurrLabels; 
clear tempCurrFeatures; 

tic; 
disp('Saving...'); 
saveToFile = [filePath datasetName '/' datasetName '_train.mat']; 
save(saveToFile,'-v7.3','allFeatures','allLabels'); 
saveTime = toc; 

saveToFile = [filePath datasetName '/' datasetName '_train_time.mat']; 
save(saveToFile,'-v7.3','readTime','saveTime'); 
