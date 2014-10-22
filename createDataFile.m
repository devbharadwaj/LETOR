fileID = fopen('Querylevelnorm.txt');
pattern1 = ' \S+:';
pattern2 = ' #docid = \S+ ';
pattern3 = ' \S+ = ';
N = 69623;
training = 55698;
test = training + 6962;
validation = test + 6963;
count = 0;

while ~feof(fileID)
    count = count + 1;
    text = fgets(fileID);
    text = regexprep(text,pattern1,' ');
    text = regexprep(text,pattern2,' ');
    text = regexprep(text,pattern3,' ');
    if count > test 
        VALID(count-test,:) = str2num(text);
    elseif count > training
        TESTS(count-training,:) = str2num(text);    
    else
        TRAIN(count,:) = str2num(text);
    end
end

TRAIN(:,2) = [];
VALID(:,2) = [];
TESTS(:,2) = [];

TRAIN(:,49) = [];
VALID(:,49) = [];
TESTS(:,49) = [];

TRAIN(:,48) = [];
VALID(:,48) = [];
TESTS(:,48) = [];

length(TRAIN)
length(VALID)
length(TESTS)

save project1_data.mat TRAIN VALID TESTS