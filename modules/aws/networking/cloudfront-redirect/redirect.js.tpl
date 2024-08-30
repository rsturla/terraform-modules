function handler(event) {
  var newUrl = "${redirect_url}"
  var statusDescription = "${redirect_status_description}"
  var statusCode = ${redirect_status_code}

  var response = {
    statusCode: statusCode,
    statusDescription: statusDescription,
    headers:
      {
        "location": {
          "value": newUrl
        }
      }
  }
  return response;
}
