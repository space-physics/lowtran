classdef TestLowtran < matlab.unittest.TestCase

methods (Test)

function test_transmission(tc)

try
  py.numpy.arange(1);
catch
  tc.assumeFail('Python not setup for Matlab');
end

T = lowtran.transmission(5, 0, [0, 60, 80], [200, 30000]);

trans = double(T{'transmission'}.values);

tc.assertEqual(trans(32), 0.9468, RelTol=1e-4)

end
end
end
