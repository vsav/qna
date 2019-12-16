import consumer from "./consumer"

consumer.subscriptions.create('QuestionsChannel', {
    connected: function() {
        return this.perform('follow');
    },

    received: function(data) {
        if (gon.user_id === data.question.user_id) return;
        $('.questions ul.list-group-flush').append(data.html);
    }
});
