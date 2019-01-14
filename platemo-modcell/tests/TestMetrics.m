classdef TestMetrics < matlab.unittest.TestCase
    % Test performance metrics
    
    methods(Test)
        function test_Epsilon(testCase)
            domPF = [2 2];
            PF = [1 0
                  0 1];
            PF2 = [2 1
                   2 1];
            testCase.assertEqual(Epsilon(PF,PF), 0);
            testCase.assertEqual(Epsilon(domPF,PF), 2);
            testCase.assertEqual(Epsilon(domPF,PF2), 1);
            testCase.assertEqual(Epsilon(-domPF,-PF), -1);
        end
    end
    
end

