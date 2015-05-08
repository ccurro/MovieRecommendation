clc; clear all; close all;

moviesFile = fopen('TagGenome/movies.bigdat');
mov = textscan(moviesFile,'%d\t%s\t%f64\n','Delimiter','\t');
m = [mov{1} mov{3}];
nm = size(m,1);
fclose(moviesFile);

tagsFile = fopen('TagGenome/tags.bigdat');
tag = textscan(tagsFile,'%d\t%s\t%f64\n','Delimiter','\t');
t = [tag{1} tag{3}];
nt = size(t,1);
fclose(tagsFile);

tagsMoviesFile = fopen('TagGenome/tag_relevance.bigdat');
tagmov = textscan(tagsMoviesFile,'%d\t%d\t%f64\n','Delimiter','\t');
mt = [tagmov{1} tagmov{2} tagmov{3}];
mtv = tagmov{3};
%mtv = zscore(mtv);
nmt = size(mt,1);
fclose(tagsMoviesFile);

ids = sortrows(t,2);
ids = ids(:,1);
ids = flipud(ids);
names = tag{2}(ids+1);

nidscor = 5;
corr = zeros(nt,nidscor+1);
corr(:,1) = t(:,1);
curvals = zeros(nidscor,1);

for ii = 1:(nmt/nm)
    ii
    for jj = 1:nidscor
        currFeatId = ids(jj);
        curvals(jj) = mt(ii+currFeatId);

    end
    for kk = 1:nt
        for jj = 1:nidscor
           if(ids(jj) == kk-1)
               continue;
           end
           corr(kk,jj+1) = corr(kk,jj+1)...
               + (curvals(jj) - mtv(ii+kk-1))^2 * double(m(ii,2));
        end
    end
end