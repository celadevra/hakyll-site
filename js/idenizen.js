$('document').ready(function() {
    $('span.tapestry').hide();
    $('span.button > a').mouseover(function() {
        $(this).parent().children('.tapestry').show().fadeIn(200);
    });
    $('span.button > a').mouseout(function() {
        $('span.tapestry').hide();
    });
});
