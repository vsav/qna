$(document).on('turbolinks:load', function(){
    $('.ratings .vote-controls .like-button').on('ajax:success', function(e) {
        var response = e.detail[0];
        var votable = '#' + response.klass + '-' + response.votable_id + '-rating';
        $(votable + ' .total-rating').html('Rating: ' + response.total_rating);
        $(votable + ' .like-button').addClass('disabled');
        $(votable + ' .dislike-button').removeClass('disabled');
        $(votable + ' .unvote-button').removeClass('disabled');
    });

    $('.ratings .vote-controls .dislike-button').on('ajax:success', function(e) {
        var response = e.detail[0];
        var votable = '#' + response.klass + '-' + response.votable_id + '-rating';
        $(votable + ' .total-rating').html('Rating: ' + response.total_rating);
        $(votable + ' .like-button').removeClass('disabled');
        $(votable + ' .dislike-button').addClass('disabled');
        $(votable + ' .unvote-button').removeClass('disabled');
    });

    $('.ratings .vote-controls .unvote-button').on('ajax:success', function(e) {
        var response = e.detail[0];
        var votable = '#' + response.klass + '-' + response.votable_id + '-rating';
        $(votable + ' .total-rating').html('Rating: ' + response.total_rating);
        $(votable + ' .like-button').removeClass('disabled');
        $(votable + ' .dislike-button').removeClass('disabled');
        $(votable + ' .unvote-button').addClass('disabled');
    });
});
