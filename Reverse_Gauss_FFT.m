clc
clear
close all
%%

try  % checking wether or not the file is even there.
    img=imread("image1.bmp");   
catch
    disp("Failed to open the image, exiting.")
    return;
end

[rows, columns, numcolors]=size(img);  % extracting proportions

inverted_gauss=zeros(rows,columns);   % generating inverted gauss function
var=(1/0.6931471806)*(1/10000)*(rows^2+columns^2);
for row=1:rows 
    for column=1:columns
        inverted_gauss(row,column)=1-exp(-1*(1/var)*((row-(rows/2)).^2+(column-(columns/2)).^2));
    end
end
figure;                          % Figure of inverted gauss
imshow(uint8(255*inverted_gauss))
title("Inverted gauss image")

if numcolors>1          % In case the image is a RGB image
    converted_image=uint8(zeros(rows,columns,numcolors));

    fft_red=fftshift(fft2(double(img(:,:,1)))).*inverted_gauss;        % converting to frequency domain and multiplying by the inverted gauss  
    fft_green=fftshift(fft2(double(img(:,:,2)))).*inverted_gauss;
    fft_blue=fftshift(fft2(double(img(:,:,3)))).*inverted_gauss;

    fft_red_restored=uint8(abs(ifft2(ifftshift(fft_red))));    % Restoring the image back to time domain and 8 bit unsigned
    fft_green_restored=uint8(abs(ifft2(ifftshift(fft_green))));
    fft_blue_restored=uint8(abs(ifft2(ifftshift(fft_blue))));

    converted_image(:,:,1)=fft_red_restored;
    converted_image(:,:,2)=fft_green_restored;
    converted_image(:,:,3)=fft_blue_restored;

else            % In case the image is a grayscale image
    fft_gray=fftshift(fft2(double(img))).*inverted_gauss;        % converting to frequency domain and multiplying by the inverted gauss
    fft_gray_restored=uint8(abs(ifft2(ifftshift(fft_gray))));    % Restoring the image back to time domain and 8 bit unsigned

    converted_image=fft_gray_restored;

end
figure;
imshow(converted_image)
imwrite(converted_image,"result.jpg")
