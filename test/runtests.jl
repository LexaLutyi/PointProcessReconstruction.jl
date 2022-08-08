using PointProcessReconstruction
using Test
using OptimizationOptimJL
using Optimization
using Flux

@testset "PointProcessReconstruction.jl" begin
    # Write your tests here.


    x0 = rand(2, 1)
    y0 = 0.1 * randn(2, 10)

    # loss_x_OF = OptimizationFunction((x, p) -> loss_x(x, p), Optimization.AutoZygote())
    fy = OptimizationFunction((x, p) -> loss_y(x, p.p) + loss_y_cross(x, p.ux, p.p), Optimization.AutoZygote())
    
    maxiters = 10
    alg = LBFGS()
    problem_kwargs = (;)
    solver_kwargs = (; maxiters)
    isshow = true
    
    s = 1

    ux = rand(2, 1)

    Ns = [32, 32]
    σs = [1 / 16, 1 / 32]
    scaled_colored_reconstruction(fy, x0, y0, ux, s; alg, problem_kwargs, solver_kwargs, isshow, Ns, σs)
end
