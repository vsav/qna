import consumer from "./consumer"

consumer.subscriptions.create( { channel: 'CommentsChannel', question_id: gon.question_id }, {
    connected: function() {
        return this.perform('follow');
    },

    received: function(data) {
        if (gon.user_id === data.comment.user_id) return;

            if (data.comment.commentable_type === 'Answer' ) {
                $('#answer-' + data.comment.commentable_id + '-comments').append(data.html);
            } else if (data.comment.commentable_type === 'Question' ){
                $('#question-' + data.comment.commentable_id + '-comments').append(data.html);
            }
    }
});
