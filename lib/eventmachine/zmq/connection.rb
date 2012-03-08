module EventMachine
  module ZMQ
    POLLIN=1
    class Connection < EventMachine::Connection
      attr_reader :socket

      def bind addr
        socket.bind addr
      end

      def connect addr
        socket.connect addr
      end

      def subscribe channel
        socket.setsockopt ::ZMQ::SUBSCRIBE, channel
      end

      def unsubscribe channel
        socket.setsockopt ::ZMQ::UNSUBSCRIBE, channel
      end

      def send_data(data, more=false)
        sndmore = more ? ::ZMQ::SNDMORE : 0

        success = socket.send(data.to_s, ::ZMQ::NOBLOCK | sndmore)
        self.notify_writable = true unless success
        success
      end

      def readable?
        r = (socket.getsockopt(::ZMQ::EVENTS) & ZMQ::POLLIN) == ZMQ::POLLIN
        r
      rescue IOError
        detach
      end

      def notify_readable
        return unless readable?

        loop do
          if msg = get_message
            receive_data msg
            while socket.getsockopt(::ZMQ::RCVMORE)
              if msg = get_message
                receive_data msg
              else
                break
              end
            end
          else
            break
          end
        end
      end

      def notify_writable
        self.notify_writable = false
      end

    private

      def get_message
        msg = socket.recv(::ZMQ::NOBLOCK)
        if msg.nil? || msg.empty?
          nil
        else
          msg
        end
      end

      def detach
        super
        socket.close
      end
    end
  end
end
