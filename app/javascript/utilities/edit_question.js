$(document).on('turbolinks:load', function () {
    $('.questions').on('click', '.edit-question-link', function (e) {
        e.preventDefault();
        console.log("123123")
        $(this).hide();
        var questionId = $(this).data('questionId');
        $('form#edit-question-' + questionId).removeClass('hidden');
    })
});