clc
clear all
s = serial('COM8', 'BaudRate', 115200);
fopen(s);
disp('Port Open');
figure(1)
image=imread('256x256_albert.jpg');
image=rgb2gray(image);
imshow(image);

source =image(:);
[m n] =size(source);
[len ~]=size(image);
m1=(len/2)*((len/2)-1);
len1 = len/2;
disp('Writing.....');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%writing data in the FPGA
temp = [source];
for i=1:m
   data=temp(i,1); 
   fwrite(s,data,'uint8');
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%waiting processor tofinish processing
disp('Sent successfully')

T = timer('TimerFcn',@(~,~)disp('Fired.'),'StartDelay',1);
start(T)
%/////////////////////////////////////////////////////
a=zeros(m1+1,1);
for k=1:m1+1
    %a=[a fread(s,1)];
    a(k,1)=fread(s,1);
end
disp('<<<<<<<<<<Receiving Completed>>>>>>>>>>>.');
fclose(s);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Reshape%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

result=a(2:m1+1);
result=uint8(result);
received= reshape(result,[len1,len1-1]);
received = received';
figure(2)
imshow(received);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%MatLAB Function%%%%%%%%%%
resized = imresize(image,0.5);
figure(3)
imshow(resized);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Error calculation%%%%%%%%%%%%%%%%%
%sent=source(1:length-1);
errorMat = reshape((resized- result),[len,len]);
SSD=sum((source- result));
disp(' Error(Sum of Squared Differnces):');
disp(SSD);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
