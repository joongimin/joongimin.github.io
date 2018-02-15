var app = new Vue({
  el: '#app',
  data: {
    winning_probability: '35.5',
    att_troops: '',
    def_troops: '',
    rolls: [
      {
        att_dices: [6, 5, 3],
        def_dices: [2, 1],
        att_troops: 15,
        def_troops: 6,
      },
      {
        att_dices: [5, 5, 1],
        def_dices: [3, 6],
        att_troops: 14,
        def_troops: 5,
      },
      {
        att_dices: [6, 5, 3],
        def_dices: [2, 1],
        att_troops: 12,
        def_troops: 3
      }
    ]
  }
});
