function v = vanishing_point(xo1, xf1, xo2, xf2)
    l1 = cross(xo1,xf1);
    l2 = cross(xo2,xf2);
    v = cross(l1,l2);