$.validator.addMethod('positiveInteger', function(value) {
    if (value != null && value != "") {
        return /^\+?(0|[1-9]\d*)$/.test(value) > 0;
    }

    return true;
}, 'Enter a positive number.');

$.validator.addMethod('youtubeVideoLink', function (value) {
    if (value != null && value != "") {
        var p = /^(?:https?:\/\/)?(?:www\.)?(?:youtu\.be\/|youtube\.com\/(?:embed\/|v\/|watch\?v=|watch\?.+&v=))((\w|-){11})(?:\S+)?$/;
        return p.test(value);
    }

    return true;
}, 'Please enter a valid Youtube video link by copy it on the browser address bar.');