import Flutter
import UIKit
import FirebaseCore
import FirebaseMessaging
import GoogleMaps

@main
@objc class AppDelegate: FlutterAppDelegate {
  private var mapsApiKeyChannel: FlutterMethodChannel?
  
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // Firebase 초기화는 Flutter 쪽에서 하므로 여기선 생략 가능
    // 하지만 알림 권한 요청은 여기서
    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self
      
      let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
      UNUserNotificationCenter.current().requestAuthorization(
        options: authOptions,
        completionHandler: { _, _ in }
      )
    } else {
      let settings: UIUserNotificationSettings =
        UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
      application.registerUserNotificationSettings(settings)
    }
    
    application.registerForRemoteNotifications()
    
    GeneratedPluginRegistrant.register(with: self)
    
    // ✅ Google Maps API 키 설정을 위한 MethodChannel 설정
    // applicationDidBecomeActive에서 설정하도록 지연
    DispatchQueue.main.async { [weak self] in
      self?.setupMapsApiKeyChannel()
    }
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
  
  // ✅ Google Maps API 키 설정을 위한 MethodChannel 설정
  private func setupMapsApiKeyChannel() {
    guard mapsApiKeyChannel == nil else { return }
    
    if let controller = window?.rootViewController as? FlutterViewController {
      let channel = FlutterMethodChannel(
        name: "com.tago/maps_api_key",
        binaryMessenger: controller.binaryMessenger
      )
      
      channel.setMethodCallHandler { (call: FlutterMethodCall, result: @escaping FlutterResult) in
        if call.method == "setApiKey" {
          if let apiKey = call.arguments as? String, !apiKey.isEmpty {
            GMSServices.provideAPIKey(apiKey)
            result(true)
          } else {
            result(FlutterError(code: "INVALID_KEY", message: "API key is empty", details: nil))
          }
        } else {
          result(FlutterMethodNotImplemented)
        }
      }
      
      mapsApiKeyChannel = channel
    }
  }
  
  override func applicationDidBecomeActive(_ application: UIApplication) {
    super.applicationDidBecomeActive(application)
    // ✅ window가 확실히 설정된 후에 MethodChannel 설정
    setupMapsApiKeyChannel()
  }
  
  // 구글 로그인을 위한 URL 핸들링
  override func application(
    _ app: UIApplication,
    open url: URL,
    options: [UIApplication.OpenURLOptionsKey : Any] = [:]
  ) -> Bool {
    return super.application(app, open: url, options: options)
  }
  
  // 🔥 FCM 토큰 등록
  override func application(_ application: UIApplication,
                            didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    Messaging.messaging().apnsToken = deviceToken
  }
}