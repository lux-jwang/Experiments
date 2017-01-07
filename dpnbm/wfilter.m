
function [ ratings ] = wfilter(triplets, min_num_1, min_num_2)   
     if min_num_1>0
         x_ids_1 = unique(triplets(:,1))'; 
         for x_id = x_ids_1
             nth = find(triplets(:,1)==x_id);
             if length(nth) < min_num_1
                 triplets(nth,:)=[];
             end
         end
     end
     
    if min_num_2>0
        x_ids_2 = unique(triplets(:,2))';
         for x_id = x_ids_2
             nth = find(triplets(:,2)==x_id);
             if length(nth) < min_num_2
                 triplets(nth,:)=[];
             end
         end
    end
      ratings = regularidx(triplets);
end

