//= require action_cable
//= require_self

window.App = (window.App || {});
window.App.cable = ActionCable.createConsumer();
