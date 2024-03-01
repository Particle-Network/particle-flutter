class ParticleInfo {
  static String projectId = "";
  static String clientKey = "";

  static set(String projectId, String clientKey) {
    ParticleInfo.projectId = projectId;
    ParticleInfo.clientKey = clientKey;
  }
}
