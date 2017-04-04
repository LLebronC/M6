function w=bilateral_weight(window,point,matrix_e,gamma_c,gamma_p)
w=exp(-abs(window-window(point,point))/gamma_c-matrix_e/gamma_p);