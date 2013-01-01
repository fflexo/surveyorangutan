
/**
 * Hack to allow jQuery to work within XHTML documents that define an xmlns
 */

/**
 * Use the given object to override the given methods in its prototype
 * with namespace-aware equivalents
 */
function addNS(obj, methods) {
    var proto = obj.constructor.prototype;
    var ns = document.documentElement.namespaceURI;
    
    for (var methodName in methods) {
        (function () {
            var methodNS = proto[methodName + "NS"];

            if (methodNS) {
                proto[methodName] = function () {
                    var args = Array.prototype.slice.call(arguments, 0);
                    args.unshift(ns);
                    return methodNS.apply(this, args);
                };
            }
        })();
    }
}

// Play nice with IE -- who doesn't need this hack in the first place
if (document.constructor) {
    // Override document methods that are used by jQuery
    addNS(document, {
        createElement: 1,
        getElementsByTagName: 1
    });

    // Override element methods that are used by jQuery
    addNS(document.createElement("div"), {
        getElementsByTagName: 1,
        getAttribute: 1,
        getAttributeNode: 1,
        removeAttribute: 1,
        setAttribute: 1
    });
}

var ignore = true;

function setPage(n) {
    ignore = true;
    //alert(window.location.hash + ': ' + n);
    window.location.hash = "#page" + n;
    ignore = false;
}

function showPage(n) {
    //alert(n);
    var pages = $('div.page');
    pages.hide();
    pages.eq(n).show();
}

// Why doesn't this work in document.load with XSLT XHtML
function startup() { 
    window.location.hash="#page1";
    var pages = $('div.page');
    var first = pages.first();
    pages.not(first).hide();

    pages.each(function(i,e) {
	$(e).append(paginate(e, i, pages.length));
    });

    $(window).bind('hashchange', function() {
	if (!ignore) {
	    var n = window.location.hash.replace(/^#page/, '')-1;
	    showPage(n);
	}
    });
}

function paginate(d, i, n) {
    var control = $('<div><span>Page '+(i+1)+' of '+n+'</span></div>');
    control.addClass("pagination");

    if (0 != i) {
	var previous = $('<button>&lt; Previous</button>');
	previous.addClass('prev');
	previous.click(function (e) {
	    $(d).hide();
	    $(d).prev('div.page').show();	
	    setPage(i);
	});
	previous.appendTo(control);
    }

    if (i+1 != n) {
	var next = $('<button>Next &gt;</button>');
	next.addClass('next');
	next.click(function (e) {
	    $(d).hide();
	    $(d).next('div.page').show();
	    setPage(i+2);
	});
	next.appendTo(control);
    }
    else {
	var done = $('input#done');
	done.appendTo(control);
	done.addClass('next');
    }
    
    return control;
}
