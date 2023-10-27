String getBackendUrl() {
  return "http://jelly-backend.azurewebsites.net${_getApiPath()}";
}

String _getApiPath() {
  return "/api/v1";
}