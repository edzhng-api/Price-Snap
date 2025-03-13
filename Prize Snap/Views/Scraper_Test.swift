import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    let url: URL
    let didFinishLoading: (String) -> Void
    
    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: WebView
        
        init(parent: WebView) {
            self.parent = parent
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                let js = """
                var price = document.querySelector('span.product-grid-cell_main-price') ? document.querySelector('span.product-grid-cell_main-price').textContent.replace(/<!--v-if-->/, '').trim() : '';
                price;
                """
                
                webView.evaluateJavaScript(js) { result, error in
                    if let result = result as? String {
                        let price = result.trimmingCharacters(in: .whitespacesAndNewlines)
                        if !price.isEmpty {
                            self.parent.didFinishLoading(price)
                        } else {
                            print("Price extraction failed: \(error?.localizedDescription ?? "No error")")
                        }
                    } else {
                        print("JavaScript result is nil: \(error?.localizedDescription ?? "No error")")
                    }
                }
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.load(URLRequest(url: url))
    }
}

struct Scraper_Test: View {
    @State private var price = ""

    var body: some View {
        VStack {
            Text("Price: \(price)")
                .font(.title)
                .padding()
        }
        .onAppear {
            guard let url = URL(string: "https://giantfood.com/product/organic-bananas-apx-4-7-ct-1-bunch/136016") else { return }
            WebView(url: url) { price in
                self.price = price
            }
        }
    }
}

struct ScraperTest_Previews: PreviewProvider {
    static var previews: some View {
        Scraper_Test()
    }
}
