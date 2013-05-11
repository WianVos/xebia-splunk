class Puppet::Provider::Splunk < Puppet::Provider
  def splunk_exec(sub_command, passed_args, splunkd_running="dc")

    # splunkd_running controls if splunkd should be running in order for this command to complete succesfully
    # dc: don't care
    # true: is should be running
    # false: it should not be running

    # get the status of splunkd
    self.debug "splunkd_running set to #{splunkd_running}"
    splunkd_ensure_status(running = splunkd_running ) unless splunkd_running == "dc"

    # initialize the two hashes we need
    args = []

    exec_args = []

    # args << "-auth #{resource[:user]}:#{resource[:password]}"

    # always add this argument to any splunk command executed
    args << "--no-prompt"

    #args.each { | arg | passed_args << arg }

    #exec_args = passed_args.join " "

    #compose the command
    command = "splunk #{sub_command} #{passed_args.join(' ')}"

    # send the command to the debug stream
    self.debug "#{command}"

    # execute the command and catch the result
    result = `#{command}`

    # check for non 0 returncodes (might change this to something wich allows for more accepted retcodes)
    self.fail result unless $?.exitstatus == 0

    # return the result

    return result

  end

  def splunkd_running?

    # check if splunkd is running
    # this method depends on splunkd being controllable with the service command

    # set running to true
    running = false
    # compose the command (a very simple one in this case)
    command = 'service splunk status'

    # send it to debugging
    self.debug "#{command}"

    # get the result of the command
    result = `#{command}`

    # output the result to the debug stream
    self .debug "#{result}"

    # if result contains the word not .. then we assume splunkd is not running
    running = true if result.include? 'splunkd is running'

    return running

  end

  def start_splunkd

    # start the splunkd daemon only
    # this method depends on splunkd being controllable with the service command

    self.debug "starting splunkd"

    # compose the command
    command = 'service splunk start'

    # send the command to the debug stream
    self.debug command

    # execute the command and capture the results
    result = `#{command}`

    # fail upon an exitcode higher than 0
    self.fail result unless $?.exitstatus == 0

  end

  def stop_splunkd

    # stop the splunkd daemon only
    # this method depends on splunkd being controllable with the service command

    self.debug "stopping splunkd"

    # compose the command .

    command = 'service splunk stop'

    # send the command to the debug stream
    self.debug command

    # execute the command and capture the result
    result = `#{command}`

    # if we encouter an exit code above 0 then fail
    self.fail result unless $?.exitstatus == 0

  end

  def splunkd_ensure_status(running=false)

    self.debug "running is #{running}"

    #check the state of the splunkd and act accordingly

    unless splunkd_running? == running
      start_splunkd if running == true
      stop_splunkd if running == false
    end
  end

  def splunk_resource_exists?( name, type="index")

    args = []

    exec_args = []

    exists = false

    args << "--no-prompt"

    exec_args = args.join " "

    command = "splunk list #{type} #{name} #{exec_args}"
    self.debug command

    result = `#{command}`

    if $?.exitstatus == 0
      exists = true
    end

    return exists

  end

end