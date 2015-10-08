jQuery.expr[':'].regex = function(elem, index, match) {
    var matchParams = match[3].split(','),
	validLabels = /^(data|css):/,
	attr = {
	    method: matchParams[0].match(validLabels) ?
		matchParams[0].split(':')[0] : 'attr',
	    property: matchParams.shift().replace(validLabels,'')
	},
	regexFlags = 'ig',
	regex = new RegExp(matchParams.join('').replace(/^s+|s+$/g,''), regexFlags);
    return regex.test(jQuery(elem)[attr.method](attr.property));
}

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
    var bannerFigure = $('img:regex(alt, banner)').parent();
    bannerFigure.hide(0, function() {
	var imagePath = bannerFigure.children().attr('src');
	$('div.content > h1').css(
	    { 'background-image': 'url(' + imagePath +')',
	      'background-position': '0% 0%',
	      'background-size': 'cover',
	      'height': '400px',
	      'box-shadow': 'inset 0px 0px 370px #000',
	      'background-repeat': 'no-repeat',
	      'background-clip': 'content-box' });
	$('div.content > h1 > span').css(
	    { 'top': '362px',
	      'background': 'none',
	      'color': '#fff' });
    });
});
