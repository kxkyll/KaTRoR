class Launchy::Application
  #
  # The class handling the browser application and all of its schemes
  #
  class Browser < Launchy::Application
    def self.schemes
      %w[ http https ftp file ]
    end

    def self.handles?( uri )
      return true if schemes.include?( uri.scheme )
      return true if File.exist?( uri.path ) and uri.scheme.nil?
    end

    def windows_app_list
      [ 'start /b' ]
    end

    def cygwin_app_list
      [ 'cmd /C start /b' ]
    end

    def darwin_app_list
      [ find_executable( "open" ) ]
    end

    def nix_app_list
      app_list = %w[ xdg-open ]
      if nix_de = Launchy::Detect::NixDesktopEnvironment.detect then
        app_list << nix_de.browser
        app_list << nix_de.fallback_browsers
      end
      app_list.flatten!
      app_list.delete_if { |b| b.nil? || (b.strip.size == 0) }
      app_list.collect { |bin| find_executable( bin ) }.find_all { |x| not x.nil? }
    end

    # use a call back mechanism to get the right app_list that is decided by the 
    # host_os_family class.
    def app_list
      host_os_family.app_list( self )
    end

    def browser_env
      return [] unless ENV['BROWSER']
      browser_env = ENV['BROWSER'].split( File::PATH_SEPARATOR )
      browser_env.flatten!
      browser_env.delete_if { |b| b.nil? || (b.strip.size == 0) }
      return browser_env
    end

    # Get the full commandline of what we are going to add the uri to
    def browser_cmdline
      possibilities = (browser_env + app_list).flatten
      possibilities.each do |p|
        Launchy.log "#{self.class.name} : possibility : #{p}"
      end
      if browser = possibilities.shift then
        Launchy.log "#{self.class.name} : Using browser value '#{browser}'"
        return browser
      end
      raise Launchy::CommandNotFoundError, "Unable to find a browser command. If this is unexpected, #{Launchy.bug_report_message}"
    end

    def cmd_and_args( uri, options = {} )
      cmd = browser_cmdline
      args = [ uri.to_s ]
      if cmd =~ /%s/ then
        cmd.gsub!( /%s/, args.shift )
      end
      return [cmd, args]
    end

    # final assembly of the command and do %s substitution 
    # http://www.catb.org/~esr/BROWSER/index.html
    def open( uri, options = {} )
      cmd, args = cmd_and_args( uri, options )
      run( cmd, args )
    end
  end
end
