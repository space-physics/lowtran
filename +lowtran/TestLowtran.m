classdef TestLowtran < matlab.unittest.TestCase

methods (Test)

function test_transmission(tc)

try
  py.numpy.arange(1);
catch
  tc.assumeFail('Python not setup for Matlab');
end

alt_km = 0;
zenithangle = [0, 60, 80];

p.model=5;
p.h1=alt_km;
p.angle=zenithangle;
p.wlshort= 200;
p.wllong=30000;

T = lowtran.transmission(p);

trans = double(T{'transmission'}.values);

tc.assertEqual(trans(32), 0.9468, RelTol=1e-4)

end
end
end
