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
    total_survivors = 0
    total_count.times do
      remaining_att_troops, remaining_def_troups = battle(att_troops, def_troops)
      win_count += 1 if remaining_def_troups.zero?
      total_survivors += remaining_att_troops
    end

    probability = (win_count.to_f / total_count.to_f * 100.0).round(1)
    average_survivors = total_survivors.to_f / total_count.to_f
    [probability, average_survivors]
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
average_survivors_list = []
calculator = RiskProbabilityCalculator.new
(1..50).each do |att_troops|
  (1..50).each do |def_troops|
    probability, average_survivors = calculator.calculate(att_troops, def_troops)
    probability_list << probability
    average_survivors_list << average_survivors
  end
end

puts 'Probability:'
puts probability_list.join(',')

puts

puts 'Average survivors:'
puts average_survivors_list.join(',')
