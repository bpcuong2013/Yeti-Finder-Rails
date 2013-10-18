var generalErrorText = "Opps! We're sorry, unexpected error occurs. Press F5 to try again.";
var _globalRootUrl = "";

function getRandomString() {
    var rand = Math.random();
    return (rand + "").replace(".", "").replace("-", "");
}

function isNullOrEmpty(str) {
    return str == null || str == "" || str == undefined;
}

function getErrorHtml(msg) {
    if (msg != null) {
        return "<div class='text-error'>" + msg + "</div>";
    }

    return "<div class='text-error'>" + generalErrorText + "</div>";
}

function getSuccessHtml(msg) {
    return "<div class='green'>" + msg + "</div>";
}


function getProcessingHtml(msg, rootUrl) {
    if (msg == null) {
        return "<div class='processing'><div class='wait_margin'><img src='" + rootUrl + "assets/waiting.gif'></img><div class='wait_text'>Processing...</div></div></div>";
    }

    return "<div class='processing'><div class='wait_margin'><img src='" + rootUrl + "assets/waiting.gif'></img><div class='wait_text'>" + msg + "</div></div></div>";
}
function isMobileMode() {
    return $(".mobile-detection").css("width") == "1px";
}
function setErrorValidation(error, element) {
    var placement = "top";
    if (isMobileMode()) {
        placement = "top";
    }

    $(element).addClass("validation-error");
    $(element).tooltip('destroy');
    $(element).tooltip({
        animation: true, placement: placement, trigger: "focus", title: $(error).text()
    });

    $(element).tooltip("show");
}

function disposeErrorValidation(label, element) {
    $(element).removeClass("validation-error");
    $(element).tooltip('destroy');
}
function validateURL(val) {
  if (val.length == 0) { return true; }

    // if user has not entered http:// https:// or ftp:// assume they mean http://
    if(!/^(https?|ftp):\/\//i.test(val)) {
        val = 'http://'+val; // set both the value
        $(elem).val(val); // also update the form element
    }
    
    // now check if valid url
    // http://docs.jquery.com/Plugins/Validation/Methods/url
    // contributed by Scott Gonzalez: http://projects.scottsplayground.com/iri/
    return /^(https?|ftp):\/\/(((([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&amp;'\(\)\*\+,;=]|:)*@)?(((\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5])\.(\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5])\.(\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5])\.(\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5]))|((([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.)+(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.?)(:\d*)?)(\/((([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&amp;'\(\)\*\+,;=]|:|@)+(\/(([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&amp;'\(\)\*\+,;=]|:|@)*)*)?)?(\?((([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&amp;'\(\)\*\+,;=]|:|@)|[\uE000-\uF8FF]|\/|\?)*)?(\#((([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&amp;'\(\)\*\+,;=]|:|@)|\/|\?)*)?$/i.test(val);
}