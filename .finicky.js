module.exports = {
  defaultBrowser: "Firefox",
  options: {
    hideIcon: true,
  },
  rewrite: [
    {
      // Redirect all urls to use https
      match: ({ url }) => url.protocol === "http",
      url: { protocol: "https" }
    }
  ],
  handlers: [
    {
      match: ["*c2fo*", "*office365*", "*microsoft*", "*slack*", "*jetbrains*", "*datadoghq*", "*aws.amazon*", "*honeycomb.jira*", "*docs.google.com*", "*drive.google.com*", "*forms.gle*"],
      browser: "/Applications/Google Chrome.app"
    },
  ]
};
