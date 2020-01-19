require_relative 'errors/errors'

module AutomatedTicketingSystem

  class Slot
    attr_accessor :id, :car

    def initialize(id)
      @id = Integer(id)
    rescue StandardError
      raise InvalidSlotNumberError
    end

    def park(car)
      raise ExistingCarInSlotError unless @car.nil?
      @car = car
    end

    def unpark
      raise SlotAlreadyEmptyError.new(nil, id) if @car.nil?
      @car = nil
    end

    def available?
      @car.nil?
    end
  end

end