$(document).on("turbolinks:load", function() {
    $("#tab-wrapper div a").click(function(e){
        e.preventDefault();

        let tabid = $(this).attr('href');

        $("#tab-wrapper div a, .tab div").removeClass("tw-active active-tab");

        $(".tab-content").hide();
        $(tabid).show();
        $(this).addClass("tw-active active-tab");
    });
});
