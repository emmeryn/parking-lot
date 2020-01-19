module AutomatedTicketingSystem
  class Command
    def self.run(*)
      raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
    end
  end
end