
 function IOTxRxRatio = HBC_transceiver_loop(EbNo, WithHBC, WithCorr, G_T, G_R)

% ====== % Important vectors in the transmitter % ====== %
% randomInput, walsh, fscOutput.

% ====== % Important vectors in the receiver % ====== %
% fscDespread, walshDespread, S2Pdespread.

%%%%%%%%%%%%%%%%%%%%% HBC Transmitter Section %%%%%%%%%%%%%%%%%%%%%
% => The HBC tranmitter, here the input is taken then further convert to 16
% walsh code format then further spreaded to fsc format. 

tic

dataRate = 4*1024;     %====> for ease of uderstanding use '4' to get an idea of process
fscSize = 64;
chipResolution = 3;  %%% defines the sampling length for a single chip


% =================== Random Input Data Generator =================== %
randomInput = round(rand (1,dataRate));   %% =====> For normal simulation  

% =================== 16 Walsh Modulation (FS Spreader) =================== %
walshvector = 16*(length(randomInput)/4) ;
walsh = zeros(1,(walshvector));
k=1;
for i = 1:4:length(randomInput)
   
    walsh(k:k+15) = orthogonal_conversion_table_lookup(randomInput(i:i+3));
    k=16+k;
end

% =================== Vector definition for correlation template =================== %

if WithCorr                                                              %% for the case of template comparison
fscONE = zeros(1,fscSize); fscONE(2:2:end)=1;                            %% template for case of 1 in fsc 
fscZERO = zeros(1,fscSize);fscZERO(1:2:end)=1;                           %% template for case of 0 in fsc 
scaledZERO = zeros(1,length(fscONE)*chipResolution);                      
scaledONE = zeros(1,length(fscONE)*chipResolution);                       

k=1;
for i = 1:length(fscONE)

     scaledONE(k:(k+(chipResolution-1))) = repmat(fscONE(i),1,chipResolution);       %% spreaded template for case of 1 in fsc
     scaledZERO(k:(k+(chipResolution-1))) = repmat(fscZERO(i),1,chipResolution);     %% spreaded template for case of 0 in fsc
     k=chipResolution+k;
end

end

% =================== Clock Signal Multiplication(FSC Spreader) =================== %
fscOutput = zeros(1,(length(walsh)*fscSize));
oneCounter = 1;

for iterator = 1:length(walsh)
    firstVal = walsh(iterator);
    if(firstVal) == 1
        fscOutput(oneCounter+1:2:(oneCounter+(fscSize)-1)) = 1;
    end
    if(firstVal) == 0
        fscOutput(oneCounter:2:(oneCounter+(fscSize)-1)) = 1;
    end
    oneCounter = oneCounter+fscSize;
end

%%%%%%%%%%%%%%%%%%%%% HBC Outside Transmitter Section %%%%%%%%%%%%%%%%%%%%%

% =================== Normalize and Spread Signal =================== %
% => The signal is spread here with a given resolution, after exiting the
% tranmitter. The plots here show number of bits transmittted in different phases
% when they have a standard time duration.


                     
%singleBitTime = 1/(41984e3);   %% Time for a single symbol and 16 walsh  
%scaledBitTime = singleBitTime / chipResolution;

S2Pratio = 4;  %% factor to identify the length of a single Symbol

%%==> calculations for fsc plot
fscvector = chipResolution*(length(fscOutput));
sampledSignal = zeros(1,(fscvector));  %% to define the length of the sampled vector 
k=1;
for i = 1:length(fscOutput)

     sampledSignal(k:(k+(chipResolution-1))) = repmat(fscOutput(i),1,chipResolution);
     k=chipResolution+k;
end

signalAmplitude = 1;  %% defines the amplitude for a single bit.
timeScaledfsc = sampledSignal*signalAmplitude;
%singletime = timeScaledfsc(1:(chipResolution*(16*fscSize)));


%Time = scaledBitTime:scaledBitTime:scaledBitTime*length(timeScaledfsc);  %% time for the simulation 

%%==> calculation for the 16 walsh plot
walshMod = walsh;
temp = zeros(1,fscvector);
k=1;
for i = 1:length(walshMod)

    temp(k:(k+((chipResolution*fscSize)-1))) = repmat(walshMod(i),1,chipResolution*fscSize);
    k=(chipResolution*fscSize)+k;
end
%scaledWalsh = temp;
%singlewalsh = scaledWalsh(1:(chipResolution*(16*fscSize)));

%%==> calculation for the S2P plot
temp = zeros(1,(fscvector));
k=1;
S2P = randomInput;
for i = 1:length(S2P)

    temp(k:(k+((chipResolution*fscSize*S2Pratio)-1))) = repmat(S2P(i),1,chipResolution*fscSize*S2Pratio);
    k=(chipResolution*fscSize*S2Pratio)+k;
end
%scaledS2P = temp;
%singleS2P = scaledS2P(1:(chipResolution*(16*fscSize)));

% =================== Bit Energy and Normalization Calculation =================== %
% => Here the energy calculation is done for the two consecutive occuring zero and one,
% which depend on the length of the incoming length of signal and the resoultiion set for
% sampling them.

%%%%%%%%%%%%%%%%%%%%% Normalizing and Sampling the incoming data sequnce %%%%%%%%%%%%%%%%%%%%%

normalizeScaledfsc = zeros(1, length(timeScaledfsc));      %% a vector to accomodate sampled vector  
sampledbit = length(timeScaledfsc) / dataRate;        %% to define the length of the single bit after sampling 

bit_energy=zeros(1,dataRate);                        %% calculation of energy of sample for bit 
for i=1:dataRate
    vectorIndex = sampledbit*(i-1)+1:i*sampledbit;                                %% defining indexes for the length to be sampled at a time
    normalization_factor = sqrt(sum(timeScaledfsc(vectorIndex).^2));              %% calculation for normalization 
    normalizeScaledfsc(vectorIndex)=timeScaledfsc(vectorIndex)./normalization_factor;
    bit_energy(i)= sum((normalizeScaledfsc(vectorIndex)).^2);                          %% energy of sampled sequence for 1 bit at S2P level
    
end

%signal_energy = sum((normalizeScaledfsc).^2);             %% just to check energy of the combined samples of bits rather than checking one by one
%%%%%%%%%%%%%%%%%%%%%%%%%%%%% HBC Channel %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if WithHBC == 1
    Hbc_channel = zeros(1,length(normalizeScaledfsc));
for loop = 1:length(Hbc_channel)
    Hbc_channel(loop) = modified_hbc_ir(normalizeScaledfsc(loop), G_T, G_R);
end

end

%%%%%%%%%%%%%%%%%%%%% Inserting AWGN to transmitted signal %%%%%%%%%%%%%%%%%%%%%
% => Here the noise is added to the transmitted signal. The noise range is
% from 1 to 20 dB. The element handling noise here is noiseFigure.

%EbNo = 1:1:20;           %% insertion of AWGN noise from 1 to 20 dB

 Noise = (1./(10.^(EbNo./10)))/2;        %% divided the noise by the normalization factor
noiseFigure = zeros((length(EbNo)),(fscvector));
for i = 1:length(EbNo)
if WithHBC == 0
    noiseFigure(i,:) = normalizeScaledfsc+(sqrt(Noise(i))*randn(1,length(normalizeScaledfsc)));
else
    noiseFigure(i,:) = Hbc_channel+(sqrt(Noise(i))*randn(1,length(Hbc_channel)));
end
end

%%%%%%%%%%%%%%%%%%%%% HBC Receiver Section %%%%%%%%%%%%%%%%%%%%%
% => The receiver section converts the data back to its original format
% from the spreaded sequence it is depreaded back to its original form. The
% main elements doing this are fscDespread, walshDespread and S2Pdespread.

IOTxRxDifference = zeros(1,length(EbNo));                        %% defines length of a vector used for BER calculation
IOTxRxRatio = zeros(1,length(EbNo));                             %% defines length of a vector used for BER calculation

for m = 1:length(EbNo);              %% !! Important, as this used to add noise of different levels to the signal

    
    if WithCorr ==0
% =================== FSC Despreading  =================== %
fscDespread = detector(noiseFigure(m,:),chipResolution,fscOutput);    %% funcion to perform conversion of rx data to fsc format

% =================== 16 walsh Despreading =================== %
walshDespread = walshdespreader(fscDespread,fscSize,walsh);    %% funcion to perform conversion of fsc format data to walsh format
    else
       walshDespread = matched_filter_despread(noiseFigure(m,:), scaledONE, scaledZERO, walshvector);
        
    end
% =================== P2S section =================== %
%=> we are not performing P2S in this section but in the simulator in the
%standard this should be done here. Over here we already have the data in
%the serial form which was coming from the walsh despreader, so over here
%we are just figuring out the corresponding S2P sequence for the incoming
%walsh sequence.

S2Pvector = 4*(length(walshDespread)/16);
S2Pdespread = zeros(1,(S2Pvector));                         %% conversion of sequence from walsh format to S2P format
k=1;
for i = 1:16:length(walshDespread)
    
    S2Pdespread(k:k+3) = lookup_rx(walshDespread(i:i+15));
    k=4+k;
end

% =================== Comparisons =================== %
%=> Here we are comparing the FSC outputs at the Tx and the Rx,                   
%walsh outputs at the Tx and Rx and finally the S2P outputs at the Tx and Rx 

[IOTxRxDifference(m),IOTxRxRatio(m)] = biterr(randomInput,S2Pdespread);        %% no. of bit differece and ratio between Tx and Rx I/O


end

toc   %% to check the execution time for the code
return

% =================== Plotting =================== %
% for i = 1:9:(length(EbNo))
%      figure(2+i);   %% for the figure plotting  <=
%      stem(Time,noiseFigure(20,:));
%      title(['Transmitted Signal with noise in dB when Eb/No = ' num2str(i)]); grid on;
%      xlabel('Time in seconds'), ylabel('Amplitude of Signal');
% end