module AutomatedTicketingSystem
  class SlotNumForCarsWithColourCommand < Command
    def self.run(car_colour, slots)
      slot_num_lines = []
      slots.each do |slot|
        next if slot.available?
        slot_num_lines.push(slot.id) if slot.car.colour == car_colour
      end

      if slot_num_lines.empty?
        'Not found'
      else
        slot_num_lines.join(', ')
      end
    end
  end
end