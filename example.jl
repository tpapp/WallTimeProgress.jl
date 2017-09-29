using WallTimeProgress
tracker = WallTimeTracker(10)   # output every 10 periods
increment!(tracker)
sleep(1)
increment!(tracker, 9)
count(tracker)
