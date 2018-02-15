var app = new Vue({
  el: '#app',
  data: {
    winning_probability: '35.5',
    att_troops: '',
    def_troops: '',
    rolls: []
  },
  watch: {
    att_troops: function() {
      this.reset();
    },
    def_troops: function() {
      this.reset();
    }
  },
  computed: {
    attackable: function() {
      last_roll = this.last_roll();
      return last_roll && last_roll.att_troops > 1 && last_roll.def_troops > 0;
    },
    blitzable: function() {
      last_roll = this.last_roll();
      return last_roll && last_roll.att_troops > 3 && last_roll.def_troops > 0;
    }
  },
  methods: {
    blitz_roll: function(el) {
      while (this.blitzable) {
        this.manual_roll();
      }
    },
    manual_roll: function(el) {
      last_roll = this.last_roll();

      att_dices_count = Math.min(last_roll.att_troops - 1, 3)
      def_dices_count = Math.min(last_roll.def_troops, 2)

      att_dices = []
      for (var i = 0; i < att_dices_count; ++i) {
        var dice_result = this.roll_dice()
        att_dices.push({value: dice_result});
      }

      def_dices = []
      for (var i = 0; i < def_dices_count; ++i) {
        var dice_result = this.roll_dice()
        def_dices.push({value: dice_result});
      }

      att_dices.sort(function(a, b){return b.value - a.value});
      def_dices.sort(function(a, b){return b.value - a.value});
      att_lost_troops = 0;
      def_lost_troops = 0;

      min_dices_count = Math.min(att_dices_count, def_dices_count);
      for (var i = 0; i < min_dices_count; ++i) {
        if (att_dices[i].value > def_dices[i].value) {
          att_dices[i].win = true
          def_lost_troops++;
        } else {
          def_dices[i].win = true
          att_lost_troops++;
        }
      }

      roll = {
        round: last_roll.round + 1,
        att_dices: att_dices,
        def_dices: def_dices,
        att_troops: last_roll.att_troops - att_lost_troops,
        def_troops: last_roll.def_troops - def_lost_troops
      }

      this.rolls.push(roll);
    },
    roll_dice: function() {
      return Math.floor((Math.random() * 6) + 1);
    },
    reset: function() {
      this.rolls = []
      this.rolls.push({
        round: 0,
        att_troops: this.att_troops,
        def_troops: this.def_troops,
        att_dices: [],
        def_dices: []
      })
    },
    last_roll: function() {
      return this.rolls[this.rolls.length - 1];
    }
  }
});
