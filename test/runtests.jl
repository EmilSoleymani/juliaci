using Test
using juliaci

@test lerp((1,1),(5,5),3) == 3.0
@test lerp((1,1),(5,5),5) == 5.0
@test lerp((0,0),(0,0),0) == 0.0
@test lerp((1,2),(10,20),5) == 10.0
