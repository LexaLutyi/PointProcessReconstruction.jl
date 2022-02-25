function reconstruction(u0, f, p; alg, problem_kwargs, solver_kwargs, isshow=true)
    prob = GalacticOptim.OptimizationProblem(f, u0, p; problem_kwargs...)
    trace = Trace(prob; isshow)
    sol = solve(prob, alg; cb=trace, solver_kwargs...)
    trace(sol.u, f(sol.u, p))
    trace
end


function pp_reconstruction(fx, x0; alg=LBFGS(), problem_kwargs, solver_kwargs, isshow=true, Ns, σs)
    e = one(eltype(x0))

    ux = rand(eltype(x0), length(x0))
    traces_x = []
    for (N, σ) in zip(Ns, σs)
        J, L, K = 3, 8, 2
        
        wp_x = WaveletParams(e / 2, N, J, L, K, σ)

        p = get_params(x0, wp_x)

        t_x = reconstruction(ux, fx, p; alg, problem_kwargs, solver_kwargs, isshow)

        ux .= t_x[end]
        push!(traces_x, t_x)

        @info "x reconstruction" N σ improvement=t_x.way_l[end] / t_x.way_l[1]
    end

    traces_x
end


function scaled_colored_reconstruction(fy, x0, y0, ux, s::Int = 2; alg=LBFGS(), problem_kwargs, solver_kwargs, isshow=true, Ns = [128, 128, 128, 128], σs = [one(eltype(y0)) / 2^n for n in 4:7])
    e = one(eltype(y0))

    uy = s * rand(eltype(y0), s * s * length(y0))
    traces_y = []
    for (N, σ) in zip(Ns, σs)
        J, L, K = 3, 8, 2
        
        wp_x = WaveletParams(e / 2, N, J, L, K, σ)
        wp_y = WaveletParams(e / 2, N, J, L, K, σ)
        wp_y_cross = WaveletParams(e / 2, N, J, L, K, 4σ)

        p = get_colored_params(x0, y0, wp_x, wp_y, wp_y_cross; s)

        py = (; p, ux)
        t_y = reconstruction(uy, fy, py; alg, problem_kwargs, solver_kwargs, isshow)

        uy .= t_y[end]
        push!(traces_y, t_y)

        @info "y reconstruction" N σ improvement=t_y.way_l[end] / t_y.way_l[1]
    end

    traces_y
end
