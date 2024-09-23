class ProjectInfo {
  final String projectNumber;
  final String projectId;
  final String projectJApiKey;

  ProjectInfo({
    required this.projectNumber,
    required this.projectId,
    required this.projectJApiKey,
  });

  factory ProjectInfo.fromJson(Map<String, dynamic> json) {
    return ProjectInfo(
      projectNumber: json['project_number'],
      projectId: json['project_id'],
      projectJApiKey: json['project_j_apikey'] ?? '', // Handle missing key
    );
  }
}

class ClientInfo {
  final String mobileSdkAppId;
  final AndroidClientInfo? androidClientInfo;
  final IosClientInfo? iosClientInfo;

  ClientInfo({
    required this.mobileSdkAppId,
    this.androidClientInfo,
    this.iosClientInfo,
  });

  factory ClientInfo.fromJson(Map<String, dynamic> json) {
    return ClientInfo(
      mobileSdkAppId: json['mobilesdk_app_id'],
      androidClientInfo: json['android_client_info'] != null
          ? AndroidClientInfo.fromJson(json['android_client_info'])
          : null,
      iosClientInfo: json['ios_client_info'] != null
          ? IosClientInfo.fromJson(json['ios_client_info'])
          : null,
    );
  }
}

class AndroidClientInfo {
  final String packageName;

  AndroidClientInfo({
    required this.packageName,
  });

  factory AndroidClientInfo.fromJson(Map<String, dynamic> json) {
    return AndroidClientInfo(
      packageName: json['package_name'],
    );
  }
}

class IosClientInfo {
  final String bundleIdentifier;

  IosClientInfo({
    required this.bundleIdentifier,
  });

  factory IosClientInfo.fromJson(Map<String, dynamic> json) {
    return IosClientInfo(
      bundleIdentifier: json['bundle_identifier'],
    );
  }
}

class HostInfo {
  final String hostInfo;
  final String hostKey;

  HostInfo({
    required this.hostInfo,
    required this.hostKey,
  });

  factory HostInfo.fromJson(Map<String, dynamic> json) {
    return HostInfo(
      hostInfo: json['host_info'],
      hostKey: json['host_key'],
    );
  }
}

class AppConfig {
  final ProjectInfo projectInfo;
  final ClientInfo clientInfo;
  final HostInfo hostInfo;

  AppConfig({
    required this.projectInfo,
    required this.clientInfo,
    required this.hostInfo,
  });

  factory AppConfig.fromJson(Map<String, dynamic> json) {
    return AppConfig(
      projectInfo: ProjectInfo.fromJson(json['project_info']),
      clientInfo: ClientInfo.fromJson(json['client_info']),
      hostInfo: HostInfo.fromJson(json['host_info']),
    );
  }
}
