function R=d_error(X,Y)  
    suma=(X(1,:)-Y(1,:)).^2+(X(2,:)-Y(2,:)).^2;
    R=sqrt(suma);