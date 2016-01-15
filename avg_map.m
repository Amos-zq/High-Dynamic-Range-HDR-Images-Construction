function newlE = avg_map(Z,w,B,g,imageNum)
%printf('==== Recover HDR Image =====');
newlE = zeros(size(Z,1),size(Z,2), 3);
for i = 1: size(Z,1)
    for j = 1:size(Z,2)
        for k = 1: 3
            up = 0;
            dn = 0;
            for l = 1: imageNum
                up = up + w(Z(i, j, k,l)+1)*(g(Z(i, j, k,l)+1,k) - B(l));
                dn = dn + w(Z(i, j, k,l)+1);
            end
            newlE(i,j,k) = up/dn;
        end
    end
end