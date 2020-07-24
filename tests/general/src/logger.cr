module General
  class CustomLogger < Shivneri::Logger

    def debug(*args)
      puts join_args(args);
    end
  end
end
