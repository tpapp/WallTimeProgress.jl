using WallTimeProgress
using Base.Test

import WallTimeProgress: next_period, _with_underscores

@testset "utilities" begin
    @test _with_underscores(199) == "199"
    @test _with_underscores(0) == "0"
    @test _with_underscores(1099) == "1_099"
    @test _with_underscores(1700000) == "1_700_000"
end

@testset "next period" begin
    @test next_period(1, 10) == 10
    @test next_period(9, 10) == 10
    @test next_period(0, 10) == 10
    @test next_period(10, 10) == 20
end

@testset "WallTimeTracker" begin
    io = IOBuffer()
    wtt = WallTimeTracker(10; output = io)
    increment!(wtt)
    increment!(wtt, 5)
    increment!(wtt, 4)
    increment!(wtt, 9)
    increment!(wtt, 9)
    output = split(String(take!(io)), '\n')
    println(output)
    @test ismatch(r"processed 10 items, [-e.0-9]+ s/item", output[1])
    @test ismatch(r"processed 28 items, [-e.0-9]+ s/item", output[2])
    @test count(wtt) == 28
    @test wtt.next_report == 30
end
