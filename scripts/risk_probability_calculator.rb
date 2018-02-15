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
    total_count.times do
      win = battle(att_troops, def_troops)
      win_count += 1 if win
    end
    (win_count.to_f / total_count.to_f * 100.0).round(1)
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

    def_troops.zero?
  end
end

rows = []
calculator = RiskProbabilityCalculator.new
(1..50).each do |att_troops|
  (1..50).each do |def_troops|
    probability = calculator.calculate(att_troops, def_troops)
    rows << probability
  end
end
puts rows.join(',')
