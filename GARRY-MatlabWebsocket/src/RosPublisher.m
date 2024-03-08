classdef RosPublisher < WebSocketClient
    properties
        rosUrl;
        topic;
        msgType;
    end

    methods
        function obj = RosPublisher(rosUrl, topic, msgType)
            obj@WebSocketClient(rosUrl);
            obj.rosUrl = rosUrl;
            obj.topic = topic;
            obj.msgType = msgType;
        end

        function publish(obj, data)
            % This function publishes a message on the specified topic
            % (currently only supports Float32. If desired, can be modified
            % to support other message types).
            msg = sprintf('{"op": "publish", "topic": "%s", "msg": {"data": %d}}', obj.topic, data);
            obj.send(char(msg))
            fprintf('Sent message: %s\n', msg);
        end
    end

    methods (Access = protected)
        function onOpen(obj,message)
            % Advertise a topic to be established on ROS
            msg = sprintf('{"op": "advertise", "topic": "%s", "type": "%s"}', obj.topic, obj.msgType);
            obj.send(char(msg));
            fprintf("Advertised?");
        end
        
        function onTextMessage(obj,message)
            % This function simply displays the message received
            fprintf('Message received:\n%s\n',message);
        end
        
        function onBinaryMessage(obj,bytearray)
            % This function simply displays the message received
            fprintf('Binary message received:\n');
            fprintf('Array length: %d\n',length(bytearray));
        end
        
        function onError(obj,message)
            % This function simply displays the message received
            fprintf('Error: %s\n',message);
        end
        
        function onClose(obj,message)
            % Unadvertise (clean up) the topic on ROS
            msg = sprintf('{"op": "unadvertise", "topic": "%s"}', obj.topic)
            obj.send(char(msg));
        end
    end
end