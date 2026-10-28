import UIKit
import Capacitor
import WebKit

class MainViewController: CAPBridgeViewController {

    override func capacitorDidLoad() {
        // iOS amplía la página al tocar un campo con letra de menos de 16 px (los de la web
        // usan 15 px) y no la devuelve a su tamaño: la web queda cortada por la derecha.
        // iOS 26 no respeta maximum-scale para ese zoom, así que dentro de la app los campos
        // usan 16 px (con 16 px iOS no amplía) y además se fija maximum-scale=1.
        let noZoom = """
        (function () {
          var s = document.createElement('style');
          s.textContent = 'input, textarea, select { font-size: 16px !important; }';
          document.head.appendChild(s);
          var m = document.querySelector('meta[name=viewport]');
          if (!m) { m = document.createElement('meta'); m.name = 'viewport'; document.head.appendChild(m); }
          var c = m.getAttribute('content') || 'width=device-width, initial-scale=1, viewport-fit=cover';
          if (!/maximum-scale/.test(c)) { m.setAttribute('content', c + ', maximum-scale=1'); }
        })();
        """
        webView?.configuration.userContentController.addUserScript(
            WKUserScript(source: noZoom, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        )

        // Red de seguridad: si aun así la página queda ampliada, se devuelve a su tamaño
        // al cerrarse el teclado.
        NotificationCenter.default.addObserver(
            self, selector: #selector(resetZoom),
            name: UIResponder.keyboardDidHideNotification, object: nil
        )
    }

    @objc private func resetZoom() {
        guard let scrollView = webView?.scrollView, scrollView.zoomScale != 1 else { return }
        scrollView.setZoomScale(1, animated: true)
    }
}
