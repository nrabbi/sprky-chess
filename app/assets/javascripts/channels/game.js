App.game = App.cable.subscriptions.create('GameChannel', {
  received: function(data) {
    $("#game").removeClass('hidden')
    return $('#game').append(this.renderNotification(data));
  },

  renderNotification: function(data) {
    return "<p>" + data.notification + "</p";
    console.log(data.notification);
  }
});