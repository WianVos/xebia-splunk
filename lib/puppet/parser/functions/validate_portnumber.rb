module Puppet::Parser::Functions

  newfunction(:validate_portnumber, :doc => <<-'ENDHEREDOC') do |args|
    Validate that all passed values are valid port numbers 
    compilation will fail if any value fails this check.

    The following values will pass:

        $portnumber = "443"
        validate_portnumber("8080")
        validate_portnumber("8080", "200", $portnumber)

    The following values will fail, causing compilation to abort:

        $some_string = "hiho"
        validate_portnumber("771271239")
        validate_portnumber($some_string)

    ENDHEREDOC

    unless args.length > 0 then
      raise Puppet::ParseError, ("validate_portnumber(): wrong number of arguments (#{args.length}; must be > 0)")
    end

    args.each do |arg|
      p arg
      unless (1..65535) === arg.to_i 
        raise Puppet::ParseError, ("#{arg.inspect} is not a valid port number")
      end
    end

  end

end