mutable struct Trace{T}
    save_every::Int
    iteration::Int
    way_x::Vector{T}
    way_l::Vector{Float64}
    isshow::Bool
end


Trace(u0::T, l::Float64; save_every::Int=1, isshow::Bool=false) where T = Trace(save_every, 0, [copy(u0)], [l], isshow)
Trace(prob; save_every::Int=1, isshow::Bool=false) = Trace(prob.u0, prob.f(prob.u0, prob.p); save_every, isshow)


Base.show(io::IO, tr::Trace) = show(io, "i = $(tr.iteration), loss = $(tr.way_l[end])")


function update_trace!(tr::Trace{T}, x::T, l) where T
    tr.iteration += 1
    if tr.iteration % tr.save_every == 0
        push!(tr.way_x, copy(x))
        push!(tr.way_l, l)
    end
end


function (trace::Trace)(x, l)
    update_trace!(trace, x, l)
    trace.isshow && println(trace)
    false
end


Base.iterate(t::Trace, state=1) = state > t.iteration + 1 ? nothing : (t.way_x[state], state + 1)
Base.eltype(::Type{Trace{T}}) where T = T
Base.length(t::Trace) = t.iteration + 1
Base.getindex(t::Trace, i) = t.way_x[i]
Base.firstindex(t::Trace) = 1
Base.lastindex(t::Trace) = t.iteration + 1
