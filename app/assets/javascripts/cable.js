//= require actioncable
//= require_self

window.App = (window.App || {});
window.App.cable = ActionCable.createConsumer();
