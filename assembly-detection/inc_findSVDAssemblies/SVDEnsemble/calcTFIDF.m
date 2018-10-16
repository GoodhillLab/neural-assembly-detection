function [data_tfidf] = calcTFIDF(data)
% TF-IDF normalization of raster data
% INPUT:
%     data: N-by-T raster matrix
% OUTPUT:
%     data_tfidf: N-by-T normalized matrix
% Shuting Han, 2018

dims = size(data);

tf = data./(ones(dims(1),1)*sum(data,1));
idf = dims(2)./(sum(data,2)*ones(1,dims(2)));
idf(isnan(idf)) = 0;
idf = log(idf);
data_tfidf = tf.*idf;

end