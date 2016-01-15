function Ld = tone_mapping(Lw,a)
%%Parameters%%
delta = min(Lw(:));
Lwhite = max(Lw(:));
k = 1;
c = 0.05;
%%%%%%%%%%%%%%%%%%

[H,W,~] = size(Lw);

% 
% F = fft2(Lw);
% fx = repmat(linspace(0,1,W), [H,1,3]);
% fy = repmat(linspace(0,1,H)', [1,W,3]);
% freq = fx.^2+fy.^2;
% s =1-c+c*k*freq./(1+k*freq); 
% Fs = F.*s;
% Lw = abs(ifft2(Fs));


avg_Lw = exp(1/(W*H)*sum(log(delta + Lw(:))));
Lm = a/avg_Lw*Lw;
Ld = Lm./(1+Lm).*(1+Lm/Lwhite^2);
imshow(Ld);