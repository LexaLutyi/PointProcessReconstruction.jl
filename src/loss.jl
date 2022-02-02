standartize(x; dims=2) = reshape(x, dims, :)

loss_x(ux, p) = L2dist(K_all(standartize(ux), p.wp_x, p.vs_x) .* p.w_x, p.k_x .* p.w_x)
loss_y(uy, p) = L2dist(K_all(standartize(uy), p.wp_y, p.vs_y) .* p.w_y, p.k_y .* p.w_y)
loss_y_cross(uy, ux, p) = L2dist(K_all(standartize(ux), standartize(uy), p.wp_xy, p.vs_x_cross, p.vs_y_cross) .* p.w_y_cross, p.k_y_cross .* p.w_y_cross)

