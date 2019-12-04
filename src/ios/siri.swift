/*
* Notes: The @objc shows that this class & function should be exposed to Cordova.
*/

import Intents
import IntentsUI

@objc(siri) class siri : CDVPlugin {

  var activity: NSUserActivity?
  var shortcutPresentedDelegate: ShortcutPresentedDelegate?

  @objc(donate:) func donate(_ command: CDVInvokedUrlCommand) {
      self.commandDelegate!.run(inBackground: {
          if #available(iOS 12.0, *) {
              // var activityParams = [
              //   "persistentIdentifier": "open-my-app",
              //   "title": "Open my app",
              //   "suggestedInvocationPhrase": "Open my app",
              //   "isEligibleForSearch": true,
              //   "isEligibleForPrediction": true,
              //   ] 

              self.activity = self.createUserActivity(from: command, makeActive: true)
              // self.activity = self.createUserActivity(from: activityParams, makeActive: true)

              // tell Cordova we're all OK
              self.sendStatusOk(command)

              return
          }

          // shortcut not donated
          self.sendStatusError(command)
      })
  }

  func createUserActivity(from command: CDVInvokedUrlCommand, makeActive: Bool) -> NSUserActivity? {
      if #available(iOS 12.0, *) {
          // corresponds to the NSUserActivityTypes
          guard let activityName = siri.getActivityName() else { return nil }

          // extract all features
          guard let persistentIdentifier = command.arguments[0] as? String else { return nil }
          guard let title = command.arguments[1] as? String else { return nil }
          let suggestedInvocationPhrase = command.arguments[2] as? String
          var userInfo = command.arguments[3] as? [String: Any] ?? [:]

          var isEligibleForSearch = true
          var isEligibleForPrediction = true

          if command.arguments.count > 5 {
              isEligibleForSearch = command.arguments[4] as? Bool ?? true
              isEligibleForPrediction = command.arguments[5] as? Bool ?? true
          }

          userInfo["persistentIdentifier"] = persistentIdentifier

          // create shortcut
          let activity = NSUserActivity(activityType: activityName)
          activity.title = title
          activity.suggestedInvocationPhrase = suggestedInvocationPhrase
          activity.persistentIdentifier = NSUserActivityPersistentIdentifier(persistentIdentifier)
          activity.isEligibleForSearch = isEligibleForSearch
          activity.isEligibleForPrediction = isEligibleForPrediction

          if (makeActive) {
              ActivityDataHolder.setUserInfo(userInfo)

              activity.needsSave = true

              // donate shortcut
              self.viewController?.userActivity = activity
          } else {
              activity.userInfo = userInfo
          }

          return activity
      } else {
          return nil
      }
  }

  func sendStatusOk(_ command: CDVInvokedUrlCommand) {
      self.send(status: CDVCommandStatus_OK, command: command)
  }

  func sendStatusError(_ command: CDVInvokedUrlCommand, error: String? = nil) {
      var message = error

      if message == nil {
          message = "Error while performing shortcut operation, user might not run iOS 12."
      }

      let pluginResult = CDVPluginResult(
          status: CDVCommandStatus_ERROR,
          messageAs: message
      )

      self.send(pluginResult: pluginResult!, command: command)
  }

  func send(status: CDVCommandStatus, command: CDVInvokedUrlCommand) {
      let pluginResult = CDVPluginResult(
          status: status
      )

      self.send(pluginResult: pluginResult!, command: command)
  }

  func send(pluginResult: CDVPluginResult, command: CDVInvokedUrlCommand) {
      self.commandDelegate!.send(
          pluginResult,
          callbackId: command.callbackId
      )
  }

  public static func getActivityName() -> String? {
      guard let identifier = Bundle.main.bundleIdentifier else { return nil }

      // corresponds to the NSUserActivityTypes
      let activityName = identifier + ".shortcut"

      return activityName
  }


  @objc(mostrarMensaje:) // Declare your function name.
  func mostrarMensaje(command: CDVInvokedUrlCommand) { // write the function code.
    /* 
     * Always assume that the plugin will fail.
     * Even if in this example, it can't.
     */
    // Set the plugin result to fail.
    var pluginResult = CDVPluginResult (status: CDVCommandStatus_ERROR, messageAs: "El plugin funciona pero peta");
    // Set the plugin result to succeed.
    pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: "El plugin funciona bien");
    // Send the function result back to Cordova.
    self.commandDelegate!.send(pluginResult, callbackId: command.callbackId);
  }
}