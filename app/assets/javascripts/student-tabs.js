$(document).on("turbolinks:load", function() {
    const anchor = $(location).attr('hash');

    $("#tab-wrapper div a:not(#exclude)").click(function(e){
        e.preventDefault();

        let heading = $(this).data("heading");
        if (heading !== undefined) {
            $("#energetic-heading").html(heading);
        }

        let tabid = $(this).attr('href');

        $("#tab-wrapper div a, .tab div").removeClass("tw-active active-tab");

        $(".tab-content").hide();
        $(tabid).show();
        $(this).addClass("tw-active active-tab");
    });

    if (anchor.length > 0 && anchor === '#parent-tab-content') {
        $(`a[href*='#parent-tab-content']`).click()
    }
});
