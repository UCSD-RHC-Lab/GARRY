classdef GarryMatlabServer < WebSocketServer
    % The Matlab server that sends both Flutter and ROS/robot data. Here,
    % the workflow is that Flutter sends the server the specific file 
    % choice we want to stream ('one', 'two', etc.). The choice string was
    % determined arbitrarily; any string will do. The choice then
    % corresponds to which file we will stream to both Flutter and ROS.
        
    properties
        % 9090 is the default rosbridge port
        % Make sure to change the IP address
        rosbridgeURL = 'ws://192.168.1.166:9090';
    end
    
    methods
        function obj = GarryMatlabServer(matlabPort, rosbridgeIP)
            %Constructor
            obj@WebSocketServer(matlabPort);
            obj.rosbridgeURL = strcat('ws://', rosbridgeIP, ':9090');
        end
    end
    
    methods (Access = protected)
        function onOpen(obj,conn,message)
            fprintf('%s\n',message)
        end
        
        function onTextMessage(obj,conn,message)
            % Debug purposes
            fprintf('Received message: %s\n', message);

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

            r = RosPublisher(obj.rosbridgeURL, "/garry/data", "garry_ros/UserData");
            r.advertise();

            % Select the right data
            array = a2Vals1;
            goalVal = goalVal1;
            switch message
                case 'two'
                    array = a2Vals2;
                    goalVal = goalVal2;
                case 'three'
                    array = a2Vals3;
                    goalVal = goalVal3;
                case 'four'
                    array = a2Vals4;
                    goalVal = goalVal4;
                case 'five'
                    array = a2Vals5;
                    goalVal = goalVal5;
            end

            i = 1;
            while i < length(array)
                val = [array(i), goalVal];
                conn.send(sprintf('%f, %f', val));
                r.publish(val);
                i = i+1;
                pause(0.05)
            end
            
            conn.send('end'); %Should let the other side close the connection
        end
        
        function onBinaryMessage(obj,conn,bytearray)
            % This function sends an echo back to the client
            conn.send(bytearray); % Echo
        end
        
        function onError(obj,conn,message)
            fprintf('%s\n',message)
        end
        
        function onClose(obj,conn,message)
            fprintf('%s\n',message)
        end
    end
end

