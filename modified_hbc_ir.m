%%%% ==========  HBC Channel Code ========== %%

function [output_signal] = modified_hbc_ir(normalizeScaledfsc, G_T, G_R)

input_signal= normalizeScaledfsc;
fs=252e6;
d_air=10;
d_body=10;
%G_T=200;
%G_R=200;

if fs<250e6
'error: sampling frequency > 250MHz';

end
if G_T>270 || G_R>270
'error: G_T and G_R ground size < 270cm^2';

end
if G_T<10 || G_R<10
'error: G_T and G_R ground size > 10cm^2';

end
if d_air>200 || d_body>200
'error: d_air and d_body < 200cm';

end
if d_air<10 || d_body<10
'error: d_air and d_body > 10cm';

end
 
% ===========Reference Parameters from measured data===========
ref_fs =2.398081534772182e+008;
normal_coeff=fs/ref_fs;
impulse_length= (1e-7)/(1/fs);              %0.1us impulse resposne
for ii=1:impulse_length
t(ii) = (ii-1)*1/fs;
if t(ii)>=0 && t(ii)<0.025e-6
A=0.00032;
t_r=0;
t_0=0.00621;
x_c=-0.00097;
w=0.00735;
elseif t(ii)>=0.025e-6 && t(ii)<0.058e-6
A=0.00003;
t_r=0.025;
t_0=0.01684;
x_c=-0.01225;
w=0.00944;
else %t>=0.058e-6
A=0.00002;
t_r=0.058;
t_0=0.05610;
x_c=0.001;
w=0.01109;
end
h_R(ii) = A*exp(-(t(ii)*1e6-t_r)/t_0).*sin(pi*(t(ii)*1e6-t_r-x_c)/w);
end
% =====================================================
 
% =============== Impulse response ==============
h_R =h_R*(randn(1,1)*0.16+1);
C_h = (0.0422*G_T-0.184)*(0.0078*G_R+0.782)*( 120.49 / (d_body+d_body*(d_air/d_body)^5) )^2;
h = h_R.*C_h/normal_coeff;
h_delay = (length(h)-1)/2;
% =====================================================
% =============== Output Signal ==============
after_ch = conv(input_signal, h);
after_ch = after_ch( 1 : length(after_ch)-h_delay*2 );
output_signal = after_ch;

return