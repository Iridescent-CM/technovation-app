function getFilestackResizeUrl(screenshotUrl, width) {
  return screenshotUrl.replace(
    "https://cdn.filestackcontent.com/",
    `https://cdn.filestackcontent.com/resize=w:${width}/`
  );
}

export { getFilestackResizeUrl };
