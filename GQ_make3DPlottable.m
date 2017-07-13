function B = make3DPlottable(A)
% Takes 3D matrix data and returns a 4-column array (X,Y,Z,C) that can be
% plotted with scatter3(B(:,1),B(:,2),B(:,3),B(:,4))
l=1;
x = size(A,1);
y = size(A,2);
z = size(A,3);
B = zeros(x*y*z,4);
for i=1:x,
    for j=1:y,
        for k=1:z,
            B(l,:) = [i,j,k,A(i,j,k)];
            l=l+1;
        end
    end
end
end