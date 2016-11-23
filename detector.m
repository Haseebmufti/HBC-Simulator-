function [outputDetector]=detector(noiseFigure, chipResolution,fscOutput)


outputDetector=zeros(1,(length(fscOutput)));
k=1;
detection = length(noiseFigure(1,:)); %% at input vector index of output vector should be referenced correctly, else it will always take first row

    for i = 1:2*chipResolution:detection
        if ( sum(noiseFigure(1,i:i+chipResolution-1))^2 > sum(noiseFigure(1,i+chipResolution:i+2*chipResolution-1))^2)
            outputDetector(k:(k+2)-1) = [1 0];
        else
            outputDetector(k:(k+2)-1)= [0 1];
        end
        k=k+2;
    end
    
    return;