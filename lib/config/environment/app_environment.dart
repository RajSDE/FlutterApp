enum AppFlavor {
  development,
  staging,
  production,
}

class AppEnvironment {
  const AppEnvironment({
    required this.flavor,
    required this.appName,
    required this.baseUrl,
    required this.connectTimeoutInMs,
    required this.receiveTimeoutInMs,
    required this.enableNetworkLogs,
    required this.useMockServer,
  });

  final AppFlavor flavor;
  final String appName;
  final String baseUrl;
  final int connectTimeoutInMs;
  final int receiveTimeoutInMs;
  final bool enableNetworkLogs;
  final bool useMockServer;

  bool get isProduction => flavor == AppFlavor.production;
  String get flavorName => switch (flavor) {
        AppFlavor.development => 'dev',
        AppFlavor.staging => 'staging',
        AppFlavor.production => 'prod',
      };

  factory AppEnvironment.fromFlavor(AppFlavor flavor) {
    switch (flavor) {
      case AppFlavor.development:
        return const AppEnvironment(
          flavor: AppFlavor.development,
          appName: 'Flutter App Dev',
          baseUrl: 'https://dev.example.com/api',
          connectTimeoutInMs: 15000,
          receiveTimeoutInMs: 15000,
          enableNetworkLogs: true,
          useMockServer: true,
        );
      case AppFlavor.staging:
        return const AppEnvironment(
          flavor: AppFlavor.staging,
          appName: 'Flutter App Staging',
          baseUrl: 'https://staging.example.com/api',
          connectTimeoutInMs: 15000,
          receiveTimeoutInMs: 15000,
          enableNetworkLogs: true,
          useMockServer: true,
        );
      case AppFlavor.production:
        return const AppEnvironment(
          flavor: AppFlavor.production,
          appName: 'Flutter App',
          baseUrl: 'https://api.example.com',
          connectTimeoutInMs: 15000,
          receiveTimeoutInMs: 15000,
          enableNetworkLogs: false,
          useMockServer: true,
        );
    }
  }
}
