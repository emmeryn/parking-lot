module AutomatedTicketingSystem
  class SlotNumberForRegistrationNumberCommand < Command
    def self.run(slots, car_reg_num)
      slot_for_reg_num = slots.find do |slot|
        slot.occupied? && slot.car.reg_num == car_reg_num
      end
      slot_for_reg_num.nil? ? 'Not found' : slot_for_reg_num.id
    end
  end
end