module AutomatedTicketingSystem
  class SlotNumForRegNumCommand
    def self.run(car_reg_num, slots)
      slots.each do |slot|
        next if slot.available?
        if slot.car.reg_num == car_reg_num
          puts slot.id
          return
        end
      end
      puts 'Not found'
    end
  end
end