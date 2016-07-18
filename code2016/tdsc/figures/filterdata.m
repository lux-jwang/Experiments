function [ ax,bx, cx ] = filterdata( testx, lowb, upb, cutf )
    %testx = testx(testx<=4 & testx>=-4);
    ax = testx(testx>upb | testx<lowb);
    bx = testx(testx<upb & testx>lowb); 
    if cutf < 0
        cx = testx;
        return
    end
    
    cx = [ax;bx(1:cutf)];
    
end

