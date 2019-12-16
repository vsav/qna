$(document).on('turbolinks:load', function(){
    $(document).on('click', '.new-comment-link', function(e) {
        e.preventDefault();
        $(this).hide();
        var commentableType = $(this).data('commentableType');
        var commentableId = $(this).data('commentableId');
        $('form#new-' + commentableType + '-' + commentableId + '-comment').removeClass('hidden');
        $('textarea#new-' + commentableType + '-comment-body').val('').focus();
    })
});
