$(document).on('turbolinks:load', function () {
  $('#question-vote').on('ajax:success', '.up-question-link, .down-question-link', function (e) {
    var question = e.detail[0];

    $(`#question-vote .up-question-link`).hide();
    $(`#question-vote .down-question-link`).hide();
    $(`#question-vote .cancel-vote-question-link`).show();
    $(`#question-vote .rating`).html(question.rating);
  }).on('ajax:success', '.cancel-vote-question-link', function (e) {
    var question = e.detail[0];

    $(`#question-vote .up-question-link`).show();
    $(`#question-vote .down-question-link`).show();
    $(`#question-vote .cancel-vote-question-link`).hide();
    $(`#question-vote .rating`).html(question.rating);
  })
})