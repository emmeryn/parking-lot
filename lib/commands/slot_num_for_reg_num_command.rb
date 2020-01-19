module AutomatedTicketingSystem
  class SlotNumForRegNumCommand < Command
    def self.run(car_reg_num, slots)
      slots.each do |slot|
        next if slot.available?
        return slot.id if slot.car.reg_num == car_reg_num
      end
      'Not found'
    end
  end
end