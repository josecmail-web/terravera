import UIKit
import Capacitor
import WebKit

class MainViewController: CAPBridgeViewController {

    override func capacitorDidLoad() {
        // iOS amplía la página al tocar un campo con letra de menos de 16 px (los de la web
        // usan 15 px) y no la devuelve a su tamaño: la web queda cortada por la derecha.
        // Con maximum-scale=1 la vista web no hace zoom (tampoco con dos dedos, como en una app).
        let viewport = """
        (function () {
          var m = document.querySelector('meta[name=viewport]');
          if (!m) { m = document.createElement('meta'); m.name = 'viewport'; document.head.appendChild(m); }
          var c = m.getAttribute('content') || 'width=device-width, initial-scale=1, viewport-fit=cover';
          if (!/maximum-scale/.test(c)) { m.setAttribute('content', c + ', maximum-scale=1'); }
        })();
        """
        webView?.configuration.userContentController.addUserScript(
            WKUserScript(source: viewport, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        )
    }
}
