%% this is a fuction for hard limiting the bons
function out =  sat_lim(in,pos_limit,neg_limit)
 n = length(in);
 for i = 1:n
     if in(i) > pos_limit(i)
         in(i) = pos_limit(i);
     elseif in(i) < neg_limit(i)
         in(i) = neg_limit(i);
     end   
 end
 
 % index_up = in>pos_limit;
 % index_low = in<neg_limit;
 % 
 % in(index_up) = pos_limit(index_up);
 % in(index_low) = neg_limit(index_low);

 out = in;    
 end