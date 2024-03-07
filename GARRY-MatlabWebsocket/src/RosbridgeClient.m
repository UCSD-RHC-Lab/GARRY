function RosbridgeClient(url, dataChoice)
    % cd over to the data folder to access the files
    baseFolder = fullfile(fileparts(mfilename('fullpath')), '..', 'data');
    cd(baseFolder);
    
    s1Data = readtable('HEBB_03_Session 1_ML.csv',Range='K2:L1631');
    s2Data = readtable('HEBB_03_Session 2_ML.csv',Range='K2:L1631');
    s3Data = readtable('HEBB_03_Session 3_ML.csv',Range='K2:L1631');
    s4Data = readtable('HEBB_91_Session_1.csv',Range='A2:B1376');
    s5Data = readtable('HEBB_91_Session_2.csv',Range='A2:B1376');
    goalVal1 = double(table2array(s1Data(2,1))); % Goal A2 Value; unused
    goalVal2 = double(table2array(s2Data(2,1)));
    goalVal3 = double(table2array(s3Data(2,1)));
    goalVal4 = (table2array(s4Data(8,2)) * 1.15);
    goalVal5 = (table2array(s5Data(1,2)) * 1.01);
    a2Vals1 = table2array(s1Data(:,2));
    a2Vals2 = table2array(s2Data(:,2));
    a2Vals3 = table2array(s3Data(:,2));
    a2Vals4 = table2array(s4Data(:,2));
    a2Vals5 = table2array(s5Data(:,2));
    
    r = RosPublisher(url, "/garry/data", "std_msgs/Float32");

    % Select the right data
    array = a2Vals1
    switch dataChoice
        case 'two'
            array = a2Vals2
        case 'three'
            array = a2Vals3
        case 'four'
            array = a2Vals4
        case 'five'
            array = a2Vals5
    end
    
    % Send messages to the ros websocket server
    % right now, only publish a2 value
    % if desired to send more values, create a custom message type
    i = 1;
    while i < length(array)
        r.publish(array(i));
        i = i+1;
        pause(0.5) % can lower this to increase send speed
    end

    r.close();
end