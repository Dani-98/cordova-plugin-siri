var exec = require('cordova/exec');

var PLUGIN_NAME = "siri"; // This is just for code completion uses.

var siri = function () { }; // This just makes it easier for us to export all of the functions at once.
// All of your plugin functions go below this. 
// Note: We are not passing any options in the [] block for this, so make sure you include the empty [] block.
siri.mostrarMensaje = function (onSuccess, onError) {
    exec(onSuccess, onError, PLUGIN_NAME, "mostrarMensaje", []);
};

siri.donate = function (options, success, error) {
    exec(success, error, PLUGIN_NAME, 'donate', [options.persistentIdentifier, options.title, options.suggestedInvocationPhrase, options.userInfo, options.isEligibleForSearch, options.isEligibleForPrediction]);
};

module.exports = siri;