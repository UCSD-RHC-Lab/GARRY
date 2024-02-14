classdef RosPublisher < handle
    properties
        rosUrl;
        topic;
        msgType;
        pub;
        msg;
    end

    methods
        function obj = RosPublisher(rosUrl, topic, msgType)
            obj.rosUrl = rosUrl;
            obj.topic = topic;
            obj.msgType = msgType;
        end

        function connect(obj)
            rosinit(obj.rosUrl);
            [obj.pub, obj.msg] = rospublisher(obj.topic, obj.msgType);
        end

        function publish(obj, data)
            obj.msg.data = data;
            send(obj.pub, obj.msg);
        end
    end
end