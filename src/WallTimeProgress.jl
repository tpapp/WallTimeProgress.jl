module WallTimeProgress

using ArgCheck: @argcheck

export WallTimeTracker

"""
    WallTimeTracker(period; output = stdout, count = 0)

Create an object that can be used to track progress through an *ex ante* unknown
number of records.

# Arguments

- `period`: incrementing the counter will display progress information after
  every `period`

- `output`: a stream for displaying progress information

- `count`: the initial count

# Usage

```julia
w = WallTimeTracker(10)
for _ in 1:100
   WallTimeProgress.increment!(w) # will print updates every 10 steps
end
```

See [`increment!`](@ref), also [`reset!`].

`Base.count` can be used to query the current count.
"""
mutable struct WallTimeTracker{Tcount <: Integer,
                               Toutput <: IO}
    period::Tcount
    output::Toutput
    count::Tcount
    next_report::Tcount
    last_count::Tcount
    last_time_ns::UInt64
    function WallTimeTracker(period::Tcount; output::Toutput = stdout,
                             count::Tcount = 0) where {Tcount, Toutput}
        @argcheck period > 0
        new{Tcount, Toutput}(period, output, 0,
                             next_period(count, period), 0, time_ns())
    end
end

"""
    next_period(count, period)

Return the smallest integer that is

1. strictly greater than `count`,

2. an integer multiple of `period`.

NOTE: we could extend `Base.ceil`, but that would be type piracy.

NOTE: for internal use, not exported.
"""
next_period(count::Integer, period::Integer) = (div(count, period) + 1) * period

function reset!(wtt::WallTimeTracker)
    wtt.last_count = wtt.count
    wtt.last_time_ns = time_ns()
    nothing
end

"""
    _with_underscores(x)

Return a string representing the integer `x`, with `_` as the thousands
separator.
"""
function _with_underscores(x::Integer)
    result = IOBuffer()
    ds = digits(x)
    n = length(ds)
    for (i, d) in enumerate(ds)
        write(result, '0' + d)
        i % 3 == 0 && i < n && write(result, '_')
    end
    String(reverse!(take!(result)))
end

function Base.show(io::IO, wtt::WallTimeTracker)
    if wtt.count > 0
        print(io, "processed $(_with_underscores(wtt.count)) records")
    else
        print(io, "(no records yet)")
    end
    Δ = (wtt.count - wtt.last_count)
    if Δ > 0
        avg = (time_ns() - wtt.last_time_ns) / (1e9 * Δ)
        print(io, ", $avg s/record")
    end
    println(io)
end

Base.count(wtt::WallTimeTracker) = wtt.count

function increment!(wtt::WallTimeTracker, step = 1)
    @argcheck step > 0
    wtt.count += step
    if wtt.count ≥ wtt.next_report
        show(wtt.output, wtt)
        reset!(wtt)
        wtt.next_report = next_period(wtt.count, wtt.period)
    end
    nothing
end

end # module
