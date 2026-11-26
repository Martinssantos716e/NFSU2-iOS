# NFSU2 iOS — protótipo 0.1

Este projeto é um teste inicial para abrir https://nfsu2.xyz em WKWebView, em orientação horizontal e sem a barra do Safari.

## Limitação importante
O launcher Android original não usa um WebView comum: ele compila Chromium 156 próprio porque o jogo depende de isolamento de origem (o README do projeto relata `PAGE-NOT-ISOLATED`). WKWebView pode não satisfazer esse requisito. Este protótipo serve para testar e registrar a compatibilidade; não é uma conversão do APK e não garante que o jogo entre.

## Compilação
O workflow `.github/workflows/build-unsigned-ipa.yml` tenta compilar no macOS do GitHub Actions e empacota um IPA **sem assinatura**. Para instalar no iPhone, o arquivo precisará ser assinado/instalado por um método compatível com o ambiente do aparelho. O SideInstaller pode exigir uma assinatura válida; isso deve ser confirmado antes de prometer instalação.

Bundle ID: `com.nfsu2.iosprototype`
Deployment target: iOS 15.0
