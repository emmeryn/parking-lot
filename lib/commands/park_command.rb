module AutomatedTicketingSystem
  class ParkCommand < Command
    def self.run(car, slots)
      free_slot = find_free_slot(slots)
      raise NoFreeSlotError unless free_slot
      free_slot.park(car)
      puts "Allocated slot number: #{free_slot.id}"
    end

    def self.find_free_slot(slots)
      slots.find(&:available?)
    end
  end
end