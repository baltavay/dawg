module Dawg
  module Serialization
    def load_int(io)
      io.read(4).unpack('l')[0]
    end

    def write_int(int, io) #32bit signed integer
      io << [int].pack('l')
    end

    def load_bigint(io) #64bit signed integer
      io.read(8).unpack('q')[0]
    end

    def write_bigint(int, io)
      io << [int].pack('q')
    end

    def write_bool(var, io)
      bool = var ? 1 : 0
      io << [bool].pack('c')
    end

    def load_bool(io)
      bool = io.read(1).unpack('c')[0]
      bool == 1 ? true : false
    end

    def write_char(char, io)
      io << [char].pack('Z4')
    end

    def load_char(io)
      io.read(4).unpack('Z4')[0].force_encoding('utf-8')
    end
  end
end
