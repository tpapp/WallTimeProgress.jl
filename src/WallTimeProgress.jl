module WallTimeProgress

using ArgCheck
using EnglishText

export WallTimeTracker, increment!, reset!

mutable struct WallTimeTracker{Tname <: AbstractString,
                               Tcount <: Integer,
                               Toutput <: IO}
    period::Tcount
    item_name::Tname
    output::Toutput
    count::Tcount
    next_report::Tcount
    last_count::Tcount
    last_time_ns::UInt64
    function WallTimeTracker(period::Tcount;
                             item_name::Tname = "item", output::Toutput = STDOUT,
                             count::Tcount = 0) where {Tname, Tcount, Toutput}
        @argcheck period > 0
        new{Tname, Tcount, Toutput}(period, item_name, output,
                                    0, next_period(count, period), 0, time_ns())
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

function Base.show(io::IO, wtt::WallTimeTracker)
    name = wtt.item_name
    print(io, wtt.count > 0 ? "processed $(ItemQuantity(wtt.count, name))" :
          "(no $(pluralize(name)) yet)")
    Δ = (wtt.count - wtt.last_count)
    if Δ > 0
        avg = (time_ns() - wtt.last_time_ns) / (1e9 * Δ)
        print(io, ", $avg s/$(name)")
    end
    println(io)
end

Base.count(wtt::WallTimeTracker) = wtt.count

function increment!(wtt::WallTimeTracker, step = 1)
    wtt.count += step
    if wtt.count ≥ wtt.next_report
        show(wtt.output, wtt)
        reset!(wtt)
        wtt.next_report = next_period(wtt.count, wtt.period)
    end
    nothing
end

end # module
