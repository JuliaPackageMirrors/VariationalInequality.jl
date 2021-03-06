using JuMP, VariationalInequality

# write your own tests here

m = VIPModel()

A = [25; 25; 75; 25; 25]
B = [0.010; 0.010; 0.001; 0.010; 0.010]
T14 = 100
p = 3

@variable(m, h[i=1:p] >= 0)

@NLexpression(m, F1, A[1]+B[1]*h[1]^2 + A[4]+B[4]*(h[1]+h[2])^2 )
@NLexpression(m, F2, A[2]+B[2]*(h[2]+h[3])^2 + A[3]+B[3]*h[2]^2 + A[4]+B[4]*(h[1]+h[2])^2 )
@NLexpression(m, F3, A[2]+B[2]*(h[2]+h[3])^2 + A[5]+B[5]*(h[3])^2 )


@NLconstraint(m, sum{h[i], i=1:p} == T14)

F = [F1, F2, F3]
correspond(m, F, h)
sol, Fval, gap = solveVIP(m, algorithm=:extra_gradient, max_iter=1000, step_size=0.01)

@assert 0<= gap1 < 1e-6

@show sol
@show gap
