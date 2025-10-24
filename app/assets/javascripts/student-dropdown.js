$(document).on("turbo:load", function () {
  $(".student-meet-your-ambassador").click(function () {
    $(".meet-your-ambassador-intro").toggle("slow", function () {});
  });
});

