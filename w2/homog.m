function x=homog(x)
    x = [x; ones(1, size(x,2))];