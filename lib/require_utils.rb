module Applitools
  module RequireUtils
    # @!visibility private
    def require_dir(dir)
      Dir[File.join(File.dirname(File.expand_path(__FILE__)), 'applitools', dir, '*.rb')].sort.each do |f|
        require f
      end
    end
  end
end
