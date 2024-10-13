clear;
clc;
close all;
addpath(genpath(pwd))
data_dir = './datasets';
dataset = 'LGG';

[p,prediction] = LICAGC(data_dir, dataset,0.3,24 ,7);
a=-log10(p);

%BIC  	   0.74 ,5, 5 
%COAD	   0.9, 92 , 5 
%GBM	   0.75 ,22, 5
%KRCCC	   0.7 ,47, 5
%LSCC	   0.01,8,5 
%Bladder   0.9 ,50, 4
%LGG       0.3,24 ,7
