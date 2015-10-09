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

// Process banner image
$('document').ready(function() {
    var bannerFigure = $('img:regex(alt, banner)').parent();
    bannerFigure.hide(0, function() {
	var imagePath = bannerFigure.children().attr('src');
	$('div.title > h1').css(
	    { 'background-image': 'url(' + imagePath +')',
	      'background-position': '0% 0%',
	      'background-size': 'cover',
	      'height': '400px',
	      'box-shadow': 'inset 0px 0px 370px #000',
	      'background-repeat': 'no-repeat',
	      'background-clip': 'content-box' });
	$('div.title > h1 > span').css(
	    { 'top': '362px',
	      'background': 'none',
	      'color': '#0cf' });
    });
});

// Display in-place notes
$('document').ready(function() {
    $('div.notes').append($('section.footnotes'));
    $('section.footnotes > hr').hide();
    $('section.footnotes > ol').css(
	{ 'list-style': 'none' });
    var front = $('div.article').position().top;
    for (var i = 1; i <= $('section.footnotes > ol > li').length; i++) {
	$('section.footnotes > ol > li[id="fn' + i + '"]').hide(0, function () {
	    console.log(i)
	    var top = $('div.article a[id="fnref' + i + '"]').position().top;
	    console.log(top)
	    $(this).css(
		{ 'position': 'absolute',
		  'top': top + front,
		  'width': '15%',
		  'word-wrap': 'break-word' });
	});
    };
    $('a[id^="fnref"]').on('click', function () {
	var i = $(this).attr("id").split("fnref")[1];
	$('section.footnotes li[id="fn'+ i +'"]').toggle();
    });
});
