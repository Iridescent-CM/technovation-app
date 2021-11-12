$(document).on("turbolinks:load", function() {
    $('#cha-student-meet').click(function() {
        $('#cha-student-intro-wrapper').toggle('slow', function() {});
    });

    $('.tw-dropdown').click(function (){
        $('.tw-dropdown-menu').toggle();
    });
});