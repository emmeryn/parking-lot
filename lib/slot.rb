require_relative '../lib/car'

module AutomatedTicketingSystem

  class Slot
    attr_accessor :id, :car

    def initialize(id)
      @id = Integer(id)
    rescue StandardError
      raise ArgumentError, 'Invalid slot number'
    end
  end

end