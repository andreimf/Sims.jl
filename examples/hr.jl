using Sims
using Winston


########################################
## Hindmarsh-Rose neuron model        ##
########################################

tend = 500.0

a = 1.0
b = 3.0
c = 1.0
d = 5.0

r = 1e-3
s = 4.0
xr = -8/5

function phi(x)
    return -a * x ^ 3 + b * x ^ 2
end

function psi(x)
    return c - d * x^2
end

#
# A device model is a function that returns a list of equations or
# other devices that also return lists of equations. The equations
# each are assumed equal to zero. So,
#    der(y) = x + 1
# Should be entered as:
#    der(y) - (x+1)
#

function HindmarshRose(I)
    x = Unknown(-1.0,"x")   
    y = Unknown("y")        
    z = Unknown("z")        
    {
     der(x) - (y + phi(x) - z + I )
     der(y) - (psi(x) - y)
     der(z) - (r * (s * (x - xr) - z))
     }
end

v   = HindmarshRose(0.1)       # returns the hierarchical model
v_f = elaborate(v)    # returns the flattened model
v_s = create_sim(v_f) # returns a "Sim" ready for simulatio

v_yout = sunsim(v_s, tend) 

plot (v_yout.y[:,1], v_yout.y[:,2])
