clc;
clear all;
addpath(genpath('../lssvmlab'));
data = csvread('./data_nodate.csv');
calendar = csvread('./calendar.csv');

X = data(:, 1:end-1);
Y = data(:, end);

[Xw, Yw] = windowizeNARX(X, Y, 1:1, 0:0);