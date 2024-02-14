classdef GarryMatlabServer < WebSocketServer
    %ECHOSERVER Summary of this class goes here
    %   Detailed explanation goes here
        
    properties
    end
    
    methods
        function obj = GarryMatlabServer(varargin)
            %Constructor
            obj@WebSocketServer(varargin{:});
        end
    end
    
    methods (Access = protected)
        function onOpen(obj,conn,message)
            fprintf('%s\n',message)
        end
        
        function onTextMessage(obj,conn,message)
            % Testing stuff %
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
            % a2Vals = cell2mat(a2Vals); %Converts to doubles
            % This function sends an echo back to the client
            if strcmp(message, 'start')
                i = 1;
                while i < 10
                    %conn.send(sprintf('you connected lets gooo %d', i)); % Echo
                    val = [a2Vals1(i), goalVal1];
                    conn.send(sprintf('%f, %f', val));
                    i = i+1;
                    pause(0.1) % Pause for 100 ms
                end
            end
            if strcmp(message, 'one') % The length of message has to be the same as 'start'
                i = 1;
                while i < length(a2Vals1)
                    val = [a2Vals1(i), goalVal1];
                    conn.send(sprintf('%f, %f', val));
                    i = i+1;
                    pause(0.05)
                end
            end
            if strcmp(message, 'two')
                i = 1;
                while i < length(a2Vals2)
                    val = [a2Vals2(i), goalVal2];
                    conn.send(sprintf('%f, %f', val));
                    i = i+1;
                    pause(0.05)
                end
            end
            if strcmp(message, 'three')
                i = 1;
                while i < length(a2Vals3)
                    val = [a2Vals3(i), goalVal3];
                    conn.send(sprintf('%f, %f', val));
                    i = i+1;
                    pause(0.05)
                end
            end
            if strcmp(message, 'four')
                i = 1;
                while i < length(a2Vals4)
                    val = [a2Vals4(i), goalVal4];
                    conn.send(sprintf('%f, %f', val));
                    i = i+1;
                    pause(0.05)
                end
            end
            if strcmp(message, 'five')
                i = 1;
                while i < length(a2Vals5)
                    val = [a2Vals5(i), goalVal5];
                    conn.send(sprintf('%f, %f', val));
                    i = i+1;
                    pause(0.05)
                end
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

