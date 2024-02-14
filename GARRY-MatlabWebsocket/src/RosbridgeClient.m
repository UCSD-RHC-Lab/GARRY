function RosbridgeClient()
    % cd over to the data folder
    baseFolder = fullfile(fileparts(mfilename('fullpath')), '..', 'data');
    cd(baseFolder);
    
    s1Data = readtable('HEBB_03_Session 1_ML.csv',Range='K2:L1631');
    s2Data = readtable('HEBB_03_Session 2_ML.csv',Range='K2:L1631');
    s3Data = readtable('HEBB_03_Session 3_ML.csv',Range='K2:L1631');
    s4Data = readtable('HEBB_91_Session_1.csv',Range='A2:B1376');
    s5Data = readtable('HEBB_91_Session_2.csv',Range='A2:B1376');
    goalVal1 = double(table2array(s1Data(2,1))); % Goal A2 Value
    goalVal2 = double(table2array(s2Data(2,1)));
    goalVal3 = double(table2array(s3Data(2,1)));
    goalVal4 = (table2array(s4Data(8,2)) * 1.15);
    goalVal5 = (table2array(s5Data(1,2)) * 1.01);
    a2Vals1 = table2array(s1Data(:,2));
    a2Vals2 = table2array(s2Data(:,2));
    a2Vals3 = table2array(s3Data(:,2));
    a2Vals4 = table2array(s4Data(:,2));
    a2Vals5 = table2array(s5Data(:,2));

    r = RosPublisher("http://localhost:8081", "/garry/data", "std_msgs/Float");
    r.connect();
    
    while true
        % Send messages to the ros websocket server            
        i = 1;

        % right now, only publish a2 value
        % if desired to send more values, use a list/array
        while i < length(a2Vals1)
            r.publish(a2Vals1(i));
            fprintf('Sent message: %s\n', a2Vals1(i));
            i = i+1;
            pause(0.5)
        end
    end
end