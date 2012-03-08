module EventMachine
  module ZMQ
    class Context < ::ZMQ::Context

      READ = [:sub, :req, :rep, :xreq, :xrep, :pull]
      WRITE = [:pub, :req, :rep, :xreq, :xrep, :push]

      def bind type, address, handler=nil, *args, &blk
        sock = socket type_const_from_args(type)
        sock.instance_variable_set(:@name, type.to_s.upcase)
        [*address].each {|addr| sock.bind addr}

        create(sock, handler, *args, &blk)
      end

      def connect type, address, handler=nil, *args, &blk
        sock = socket type_const_from_args(type)
        sock.instance_variable_set(:@name, type.to_s.upcase)
        [*address].each {|addr| sock.connect addr}

        create(sock, handler, *args, &blk)
      end

      private

      def create sock, handler=nil, *args, &blk
        klass = EM.send(:klass_from_handler, Connection, handler, *args)
        conn = EM.watch(sock.getsockopt(::ZMQ::FD), klass, *args, &blk)
        conn.instance_variable_set(:@socket, sock)
        name = sock.instance_variable_get(:@name)
        if READ.include? name.downcase.to_sym
          conn.notify_readable if conn.readable?
          conn.notify_readable = true
        end

        if WRITE.include? name.downcase.to_sym
          conn.notify_writable = true
        end
        conn
      end

      def type_const_from_args arg
        arg.is_a?(Symbol) ? ::ZMQ.const_get(arg.to_s.upcase) : arg
      end

    end
  end
end
