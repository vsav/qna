import consumer from "./consumer"

consumer.subscriptions.create({ channel: "AnswersChannel", question_id: gon.question_id }, {
    connected: function() {
        return this.perform('follow');
    },

    received: function(data) {
        if (gon.user_id === data.answer.user_id) return;

        var answerHTML = data.html;
        var authorLinks = $('<div class="author-links ml-3 mt-3"></div>');
        var commentLink = $('<a class="new-comment-link ml-3 mb-3 mt-3" data-commentable-type="answer" data-commentable-id="'+ data.answer_id + '" href="#">Leave comment</a>');
        var setBestLink = $('<a id="set-best-answer-link-'+ data.answer.id +' " data-remote="true" rel="nofollow" data-method="patch" href="/answers/'+ data.answer.id +'/set_best">Mark as best</a>');

        $('.answers').append(answerHTML);

        if (gon.user_id === data.question.user_id) {
            $('#answer-'+ data.answer.id).append(authorLinks);
            $(authorLinks).append(setBestLink)
        }

        if (gon.user_id !== null) {
            $('#answer-' + data.answer.id).append(commentLink);
            $('#answer-' + data.answer.id + ' .like-button').removeClass('disabled');
            $('#answer-' + data.answer.id + ' .dislike-button').removeClass('disabled');
        }
    }
});
