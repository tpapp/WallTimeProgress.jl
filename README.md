# WallTimeProgress

[![Project Status: WIP – Initial development is in progress, but there has not yet been a stable, usable release suitable for the public.](http://www.repostatus.org/badges/latest/wip.svg)](http://www.repostatus.org/#wip)
[![Build Status](https://travis-ci.org/tpapp/WallTimeProgress.jl.svg?branch=master)](https://travis-ci.org/tpapp/WallTimeProgress.jl)
[![Coverage Status](https://coveralls.io/repos/tpapp/WallTimeProgress.jl/badge.svg?branch=master&service=github)](https://coveralls.io/github/tpapp/WallTimeProgress.jl?branch=master)
[![codecov.io](http://codecov.io/github/tpapp/WallTimeProgress.jl/coverage.svg?branch=master)](http://codecov.io/github/tpapp/WallTimeProgress.jl?branch=master)

Report progress while processing an ex ante unknown number of items.

## Usage

```julia
julia> using WallTimeProgress

julia> tracker = WallTimeTracker(10)   # output every 10 periods
(no items yet)


julia> increment!(tracker)

julia> sleep(1)

julia> increment!(tracker, 9)
processed 10 items, 0.1019247994 s/item

julia> count(tracker)
10
```

See `?WallTimeTracker` for options.
