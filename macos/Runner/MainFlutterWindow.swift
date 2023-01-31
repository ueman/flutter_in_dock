import Cocoa
import FlutterMacOS

class MainFlutterWindow: NSWindow {
  override func awakeFromNib() {
    let flutterViewController = FlutterViewController.init()
    let windowFrame = self.frame
    self.contentViewController = flutterViewController
    self.setFrame(windowFrame, display: true)

    RegisterGeneratedPlugins(registry: flutterViewController)
      
    let controller = self.contentViewController as! FlutterViewController
      let channel = FlutterMethodChannel(name: "sync", binaryMessenger: controller.engine.binaryMessenger)
    channel.setMethodCallHandler(handleMessage)

    super.awakeFromNib()
  }
  private func handleMessage(call: FlutterMethodCall, result: FlutterResult) {
    if call.method != "sync" {
      fatalError("fatalError")
    }
    let uintInt8List =  call.arguments as! FlutterStandardTypedData
    let byte = [UInt8](uintInt8List.data)
      let imageView = NSImageView()
      imageView.image = NSImage(data: Data(byte))
      NSApp.dockTile.contentView = imageView
      NSApp.dockTile.display()
  }
}
