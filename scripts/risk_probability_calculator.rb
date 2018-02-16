class RiskProbabilityCalculator
  PROBABILITIES = {
    1 => {
      1 => {
        win: 15.0 / 36.0,
        lose: 21.0 / 36.0
      },
      2 => {
        win: 55.0 / 216.0,
        lose: 161.0 / 216.0
      }
    },
    2 => {
      1 => {
        win: 125.0 / 216.0,
        lose: 91.0 / 216.0
      },
      2 => {
        win: 295.0 / 1296.0,
        lose: 581.0 / 1296.0,
        tie: 420.0 / 1296.0
      }
    },
    3 => {
      1 => {
        win: 855.0 / 1296.0,
        lose: 441.0 / 1296.0
      },
      2 => {
        win: 2890.0 / 7776.0,
        lose: 2275.0 / 7776.0,
        tie: 2611.0 / 7776.0
      }
    }
  }.freeze

  def calculate(att_troops, def_troops)
    total_count = 1000
    win_count = 0
    total_att_survivors = 0
    total_def_survivors = 0
    total_count.times do
      remaining_att_troops, remaining_def_troops = battle(att_troops, def_troops)
      win_count += 1 if remaining_def_troops.zero?
      total_att_survivors += remaining_att_troops
      total_def_survivors += remaining_def_troops
    end

    probability = (win_count.to_f / total_count.to_f * 100.0).round(1)
    average_att_survivors = total_att_survivors.to_f / total_count.to_f
    average_def_survivors = total_def_survivors.to_f / total_count.to_f
    [probability, average_att_survivors, average_def_survivors]
  end

  def battle(att_troops, def_troops)
    while att_troops > 1 && def_troops > 0
      a = [att_troops - 1, 3].min
      d = [def_troops, 2].min

      probability = PROBABILITIES[a][d]
      r = rand
      if probability[:tie]
        if r < probability[:win]
          def_troops -= [a, d].min
        elsif r < probability[:win] + probability[:lose]
          att_troops -= [a, d].min
        else
          att_troops -= 1
          def_troops -= 1
        end
      else
        if r < probability[:win]
          def_troops -= [a, d].min
        else
          att_troops -= [a, d].min
        end
      end
    end

    [att_troops, def_troops]
  end
end

probability_list = []
average_att_survivors_list = []
average_def_survivors_list = []
calculator = RiskProbabilityCalculator.new
(1..50).each do |att_troops|
  (1..50).each do |def_troops|
    probability, average_att_survivors, average_def_survivors = calculator.calculate(att_troops, def_troops)
    probability_list << probability
    average_att_survivors_list << average_att_survivors
    average_def_survivors_list << average_def_survivors
  end
end

puts 'Probability:'
puts probability_list.join(',')

puts

puts 'Average attacker survivors:'
puts average_att_survivors_list.join(',')

puts

puts 'Average defender survivors:'
puts average_def_survivors_list.join(',')
