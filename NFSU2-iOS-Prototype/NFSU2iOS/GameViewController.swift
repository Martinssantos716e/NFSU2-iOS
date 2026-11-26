import UIKit
import WebKit

final class GameViewController: UIViewController, WKNavigationDelegate, WKUIDelegate {
    private let gameURL = URL(string: "https://nfsu2.xyz")!
    private var webView: WKWebView!
    private let statusLabel = UILabel()
    private let reloadButton = UIButton(type: .system)
    private let progress = UIProgressView(progressViewStyle: .default)
    private var progressObservation: NSKeyValueObservation?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        configureWebView()
        configureStatusUI()
        loadGame()
    }

    private func configureWebView() {
        let content = WKUserContentController()
        let config = WKWebViewConfiguration()
        config.userContentController = content
        config.allowsInlineMediaPlayback = true
        config.mediaTypesRequiringUserActionForPlayback = []
        config.preferences.javaScriptCanOpenWindowsAutomatically = false

        webView = WKWebView(frame: .zero, configuration: config)
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.navigationDelegate = self
        webView.uiDelegate = self
        webView.isOpaque = false
        webView.backgroundColor = .black
        webView.scrollView.backgroundColor = .black
        webView.scrollView.contentInsetAdjustmentBehavior = .never
        webView.allowsBackForwardNavigationGestures = false
        view.addSubview(webView)

        NSLayoutConstraint.activate([
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        progressObservation = webView.observe(\.estimatedProgress, options: [.new]) { [weak self] webView, _ in
            DispatchQueue.main.async {
                self?.progress.progress = Float(webView.estimatedProgress)
                self?.progress.isHidden = webView.estimatedProgress >= 1
            }
        }
    }

    private func configureStatusUI() {
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        statusLabel.text = "Preparando NFSU2…"
        statusLabel.textColor = .white
        statusLabel.font = .systemFont(ofSize: 13, weight: .medium)
        statusLabel.backgroundColor = UIColor.black.withAlphaComponent(0.72)
        statusLabel.textAlignment = .center
        statusLabel.layer.cornerRadius = 8
        statusLabel.clipsToBounds = true
        statusLabel.isHidden = true
        view.addSubview(statusLabel)

        progress.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(progress)

        reloadButton.translatesAutoresizingMaskIntoConstraints = false
        reloadButton.setTitle("Recarregar jogo", for: .normal)
        reloadButton.setTitleColor(.white, for: .normal)
        reloadButton.backgroundColor = UIColor.black.withAlphaComponent(0.75)
        reloadButton.layer.cornerRadius = 10
        reloadButton.addTarget(self, action: #selector(loadGame), for: .touchUpInside)
        view.addSubview(reloadButton)

        NSLayoutConstraint.activate([
            progress.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            progress.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            progress.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            statusLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            statusLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            statusLabel.widthAnchor.constraint(lessThanOrEqualTo: view.widthAnchor, multiplier: 0.9),
            statusLabel.heightAnchor.constraint(equalToConstant: 34),
            reloadButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            reloadButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -12),
            reloadButton.heightAnchor.constraint(equalToConstant: 42),
            reloadButton.widthAnchor.constraint(equalToConstant: 150)
        ])
    }

    @objc private func loadGame() {
        statusLabel.isHidden = false
        statusLabel.text = "Carregando NFSU2…"
        reloadButton.isHidden = true
        webView.load(URLRequest(url: gameURL, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 30))
    }

    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        statusLabel.isHidden = false
        statusLabel.text = "Conectando ao nfsu2.xyz…"
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        statusLabel.isHidden = true
        reloadButton.isHidden = false
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        showLoadError(error)
    }

    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        showLoadError(error)
    }

    private func showLoadError(_ error: Error) {
        statusLabel.isHidden = false
        statusLabel.text = "Falha ao carregar. Toque em Recarregar jogo."
        reloadButton.isHidden = false
        print("NFSU2 WebKit error: \(error.localizedDescription)")
    }

    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        guard let url = navigationAction.request.url else {
            decisionHandler(.cancel); return
        }
        if url.scheme == "https" || url.scheme == "http" {
            decisionHandler(.allow)
        } else {
            decisionHandler(.cancel)
        }
    }

    override var prefersStatusBarHidden: Bool { true }
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask { .landscape }
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation { .landscapeRight }
}
