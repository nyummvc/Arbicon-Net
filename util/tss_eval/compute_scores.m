
function [ faccs, segIUR ] = compute_scores( mask, flow, maskGT, flowGT, thresholds )

    if ~isempty(mask)
        segIUR = sum(sum(maskGT & mask)) / sum(sum(maskGT | mask));
    else
        segIUR = 0;
    end
    
    if ~isempty(flow)
        fvalidGT = flowGT(:,:,1) < 1e9;
        nvalidGT = sum(fvalidGT(:));
        ferror = sum((flow - flowGT).^2, 3).^0.5;

        for t = 1:length(thresholds)
            faccs(t) = 1.0 - sum(ferror(fvalidGT) > thresholds(t)) / nvalidGT;
        end
    else
        faccs = zeros(size(thresholds));
    end
end

