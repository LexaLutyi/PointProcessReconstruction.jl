function scale(wp::WaveletParams, s::Int)
    WaveletParams(wp.s * s, wp.N * s, wp.J, wp.L, wp.K, wp.σ)
end


function get_colored_params(x0, y0, wp_x, wp_y=wp_x, wp_xy=wp_y; s::Int=2)
    vs_x = v_λ_k_all(x0, wp_x)
    vs_y = v_λ_k_all(y0, wp_y)
    vs_x_cross = v_λ_k_all(x0, wp_xy)
    vs_y_cross = v_λ_k_all(y0, wp_xy)

    k_x = K_all(x0, wp_x, vs_x)
    k_y = K_all(y0, wp_y, vs_y)
    k_y_cross = K_all(x0, y0, wp_xy, vs_x_cross, vs_y_cross)

    # w_x = 1 ./ abs.(k_x)
    # w_y = 1 ./ abs.(k_y)
    # w_y_cross = 1 ./ abs.(k_y_cross)
    w_x = 1 ./ W_all(x0, wp_x, vs_x)
    w_y = 1 ./ W_all(y0, wp_y, vs_y)
    w_y_cross = 1 ./ W_all(x0, y0, wp_xy, vs_x_cross, vs_y_cross)

    if maximum([w_x; w_y; w_y_cross]) > 10_000
        w_x = min.(w_x, 10_000)
        w_y = min.(w_y, 10_000)
        w_y_cross = min.(w_y_cross, 10_000)
        @warn "weights are too big"
    end

    (;
        x0,
        y0,
        wp_x = scale(wp_x, s),
        wp_y = scale(wp_y, s),
        wp_xy = scale(wp_xy, s),
        vs_x,
        vs_y,
        vs_x_cross,
        vs_y_cross,
        k_x,
        k_y,
        k_y_cross,
        w_x,
        w_y,
        w_y_cross
    )
end


