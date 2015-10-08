$('document').ready(function() {
    $('span.tapestry').hide();
    $('span.button > a').mouseover(function() {
        $(this).parent().children('.tapestry').show().fadeIn(200);
    });
    $('span.button > a').mouseout(function() {
        $('span.tapestry').hide();
    });
});

$('document').ready(function() {
    $('figure:first').hide(0, function() {
	var imagePath = $('figure:first').children().attr('src');
	$('div.content > h1').css(
	    { 'background-image': 'url(' + imagePath +')',
	      'background-position': '0% 0%',
	      'background-size': 'cover',
	      'height': '400px',
	      'background-repeat': 'no-repeat',
	      'background-clip': 'content-box' });
	$('div.content > h1 > span').css(
	    { 'top': '362px' });
    });
});
