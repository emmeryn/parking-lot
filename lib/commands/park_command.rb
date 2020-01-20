require_relative '../models/car'

module AutomatedTicketingSystem
  class ParkCommand < Command
    def self.run(slots, car_reg_num, car_colour)
      car = Car.new(car_reg_num, car_colour)

      free_slot = find_free_slot(slots)
      raise NoFreeSlotError unless free_slot
      free_slot.park(car)
      "Allocated slot number: #{free_slot.id}"
    end

    def self.find_free_slot(slots)
      slots.find(&:available?)
    end
  end
end