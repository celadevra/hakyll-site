$('document').ready(function() {
    $('div.tapestry').hide();
    $('span.button > a').mouseover(function() {
        $(this).parent().children('.tapestry').show().fadeIn(200);
    });
    $('span.button > a').mouseout(function() {
        $('div.tapestry').hide();
    });
});
