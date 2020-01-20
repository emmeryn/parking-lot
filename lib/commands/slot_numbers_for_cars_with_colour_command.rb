module AutomatedTicketingSystem
  class SlotNumbersForCarsWithColourCommand < Command
    def self.run(slots, car_colour)
      slot_num_lines = []
      slots.each do |slot|
        next if slot.available?
        slot_num_lines.push(slot.id) if slot.car.colour.casecmp?(car_colour)
      end

      if slot_num_lines.empty?
        'Not found'
      else
        slot_num_lines.join(', ')
      end
    end
  end
end