# Aquarium
SettingViewController is the launch point for the app.</BR>
And If the IP which is typed by user is available, the app will automatically switch to the next page, WebViewController. </BR>
In addition, I classify the files which are under the project into four types as below:</BR>
  - ViewController: each view used to interact with user.
  - Tools: including third party SDK and other common functions.
  - Models: Data structure.
  - StringTables: text of UI components which are in multi-language.
</BR>
I manage the third party SDK by CocoaPods, so I think you may need to install it first. 


----
## CocoaPods
  - install cocoapods</BR>
  <code>sudo gem install cocoapods</code>
  
  
----
## Spec
  - home page: </BR>
    <code>http://192.168.1.1:10240/mobile/sensor </code>
  - send a register request before launching home page. </BR>
 <code>
 http://192.168.1.1:10240/device/signageregister?json={"appCode":"fish_android","appKey":"a94502f9384c3f09725341220bfdc53cae37fafcce85d050bd","serialNumber":"unknown","os":"Android","osVersion":"7.0","heightPixel":"1794","widthPixel":"1080","macAddress":"02:00:00:00:00:00","pushNotificationId":"eie093kmc9dmme"}
  </code>

