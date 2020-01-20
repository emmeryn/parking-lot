module AutomatedTicketingSystem

  class Car
    attr_accessor :reg_num, :colour

    def initialize(reg_num, colour)
      @reg_num = reg_num
      @colour = colour
    end
  end
end