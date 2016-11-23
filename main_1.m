clear all;
close all;
clc;

tic

calculation = date;                                                      %% stores the date for simulation%% stores the date for simulation
timing = rem(now,1);
lim = 10e-7;                                                             %% range for the theoretical BER 
iterations = 250;                                                         %% Numer of iterations for the loop to run
EbNo = 1:1:80;                                                           %% The Eb/No range 

BER_A_ED = zeros(iterations, length(EbNo));
BER_A_MF = zeros(iterations, length(EbNo));
BER_H_MF = zeros(iterations, length(EbNo));
BER_H_ED = zeros(iterations, length(EbNo));
rc=1;      result_count=20;                                              %% total avg variables to be saved
result =zeros(result_count, length(EbNo));                               %% result variable to be saved

disp('AWGN with ED detection');
%%%%%%%%%%%%%%%%%%%%%%%% AWGN Calculation for ED Scheme %%%%%%%%%%%%%%%%%%%%%%%%%%%

WithHBC = 0;                                                             %% 0 means AWGN, 1 means HBC  

WithCorr = 0;                                                            %% for the template comparison, 0 means ED scheme and 1 means correlation scheme 
                                                                    

%%%%  AWGN BER calculation %%%%

G_T = 0; G_R=0;                                                          %% Transmitter and Receiver ground size

for i = 1:iterations
       
BER_A_ED(i,:) =   HBC_transceiver_loop(EbNo, WithHBC, WithCorr, G_T, G_R);
        
end

Avg_awgn = sum(BER_A_ED,1)./iterations;                                       %% Averaging BER for AWGN                               
result(rc,:) = Avg_awgn;                                                 %% Storing the average BER value in the vector
rc=rc+1; 

disp('AWGN with MF detection');
%%%%%%%%%%%%%%%%%%%%%%%% AWGN Calculation for Correlation Scheme %%%%%%%%%%%%%%%%%%%%%%%%%%%

WithHBC = 0;                                                             %% 0 means AWGN, 1 means HBC  

WithCorr = 1;                                                            %% for the template comparison, 0 means ED scheme and 1 means correlation scheme


%%%%  AWGN BER calculation %%%%

for i = 1:iterations
       
BER_A_MF(i,:) =   HBC_transceiver_loop(EbNo, WithHBC, WithCorr, G_T, G_R);
        
end

Avg_awgn = sum(BER_A_MF,1)./iterations;                                       %% Averaging BER for AWGN                               
result(rc,:) = Avg_awgn;                                                 %% Storing the average BER value in the vector
rc=rc+1;                                                           

disp('HBC with MF detection');
%%%%  HBC and AWGN BER Calculation for Correlation Scheme %%%%

G_R = 200:50:300;                                                        %% G_T value from the HBC channel
G_T = 270;                                                               %% G_R value form the HBC channel

WithHBC = 1;                                                             %% 0 means AWGN, 1 means HBC

WithCorr = 1;                                                            %% for the template comparison, 0 means ED scheme and 1 means correlation scheme

for x = 1:length(G_T)
  
   for y = 1:length(G_R)
         for i = 1:iterations    
              BER_H_MF(i,:) =   HBC_transceiver_loop(EbNo, WithHBC, WithCorr, G_T(x), G_R(y));
         end

Avg = sum(BER_H_MF,1)./iterations;                                            %% Averaging BER for HBC+AWGN
result(rc,:) = Avg;                                                      %% for the template comparison, 0 means ED scheme and 1 means correlation scheme
rc=rc+1;          
   end
end

disp('HBC with ED detection');
%%%%  HBC and AWGN BER Calculation for ED Scheme %%%%

G_R = 200:50:300;                                                        %% G_T value from the HBC channel
G_T = 270;                                                               %% G_R value form the HBC channel

WithHBC = 1;                                                             %% 0 means AWGN, 1 means HBC

WithCorr = 0;                                                            %% for the template comparison, 0 means ED scheme and 1 means correlation scheme

for x = 1:length(G_T)
  
   for y = 1:length(G_R)
         for i = 1:iterations    
              BER_H_ED(i,:) =   HBC_transceiver_loop(EbNo, WithHBC, WithCorr, G_T(x), G_R(y));
         end

Avg = sum(BER_H_ED,1)./iterations;                                            %% Averaging BER for HBC+AWGN
result(rc,:) = Avg; 
rc=rc+1;

   end
end

figure(1);
xlabel('BER'),ylabel('E_b/N_0'); 

pe1 = 0.5*(exp(-.5*db2lin(EbNo)))+qfunc(sqrt(db2lin(EbNo)));             %% non coherent OOK theoretical BER equation 
pe1(pe1<lim) = 0;
                                                                     
pe2 = qfunc(sqrt(db2lin(EbNo)));                                         %% coherent OOK theoretical BER equation
pe2(pe2<lim) = 0;

pe3 = qfunc(sqrt(2*db2lin(EbNo)));                                       %% BPSK theoretical BER equation
pe3(pe3<lim) = 0;
lg = [];                                                                 %% describing for legend

semilogy(EbNo, result(1,:),'LineWidth',1,'LineStyle','-','Marker','*'); hold on;
lg = [lg; 'AWGN with ED Detection   '];
semilogy(EbNo, result(2,:),'LineWidth',1,'LineStyle','-','Marker','*'); 
lg = [lg; 'AWGN with MF Detection   '];
semilogy(EbNo, pe1,'LineWidth',1,'LineStyle','--','Marker','o');
lg = [lg; 'Theoretical NC OOK       '];
semilogy(EbNo, pe2,'LineWidth',1,'LineStyle','--','Marker','o');
lg = [lg; 'Theoretical C OOK        '];
semilogy(EbNo, pe3,'LineWidth',1,'LineStyle','--','Marker','o');
lg = [lg; 'Theoretical BPSK         '];
legend(lg);
title('Theoretical and Simulated AWGN BER');
grid on;

lg = [];
figure(2);
xlabel('BER'),ylabel('E_b/N_0'); 

semilogy(EbNo, result(1,:),'LineWidth',1,'LineStyle','-','Marker','*'); hold on;                                    %% Simulated BER plots for AWGN
lg = [lg; 'AWGN with ED detection   '];
semilogy(EbNo, result(2,:),'LineWidth',1,'LineStyle','-','Marker','*'); 
lg = [lg; 'AWGN with MF Detection   '];

semilogy(EbNo, result(3,:),'LineWidth',1,'LineStyle','--','Marker','o');                                             %% Simulated HBC plots with correlation scheme 
lg = [lg; 'HBC With MF Detect  Gt200'];
semilogy(EbNo, result(4,:),'LineWidth',1,'LineStyle','--','Marker','o'); 
lg = [lg; 'HBC With MF Detect  Gt250'];
semilogy(EbNo, result(5,:),'LineWidth',1,'LineStyle','--','Marker','o'); 
lg = [lg; 'HBC With MF Detect  Gt300'];


semilogy(EbNo, result(6,:),'LineWidth',1,'LineStyle','--','Marker','o');                                             %% Simulated HBC plots with ED scheme
lg = [lg; 'HBC With ED Detect  Gt200'];
semilogy(EbNo, result(7,:),'LineWidth',1,'LineStyle','--','Marker','o'); 
lg = [lg; 'HBC With ED Detect  Gt250'];
semilogy(EbNo, result(8,:),'LineWidth',1,'LineStyle','--','Marker','o'); 
lg = [lg; 'HBC With ED Detect  Gt300'];
title('Simulated AWGN HBC BER');
grid on;

legend(lg);

filename = sprintf('%s_HBC_simulations%s.mat',calculation,timing);
save(filename,'Avg_awgn','Avg','EbNo','BER_A_ED','BER_A_MF','BER_H_MF','BER_H_ED','result','iterations','lim','G_T','G_R');
toc