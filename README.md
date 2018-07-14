# WallTimeProgress

![Lifecycle](https://img.shields.io/badge/lifecycle-experimental-orange.svg)
[![Build Status](https://travis-ci.org/tpapp/WallTimeProgress.jl.svg?branch=master)](https://travis-ci.org/tpapp/WallTimeProgress.jl)
[![Coverage Status](https://coveralls.io/repos/tpapp/WallTimeProgress.jl/badge.svg?branch=master&service=github)](https://coveralls.io/github/tpapp/WallTimeProgress.jl?branch=master)
[![codecov.io](http://codecov.io/github/tpapp/WallTimeProgress.jl/coverage.svg?branch=master)](http://codecov.io/github/tpapp/WallTimeProgress.jl?branch=master)

Report progress while processing an ex ante unknown number of records.

## Usage

```julia
julia> using WallTimeProgress

julia> tracker = WallTimeTracker(10)   # output every 10 periods
(no records yet)


julia> increment!(tracker)

julia> sleep(1)

julia> increment!(tracker, 9)
processed 10 records, 0.1019247994 s/record

julia> count(tracker)
10
```

See `?WallTimeTracker` for options.
