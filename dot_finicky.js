module.exports = {
  defaultBrowser: "Firefox",
  options: {
    hideIcon: true,
  },
  rewrite: [
    {
      // Redirect all urls to use https unless the URL link is not directed at localhost
      match: ({ url }) => url.protocol === "http" && !url.host.includes('localhost'),
      url: { protocol: "https" }
    },
  ],
  handlers: [
    {
      match: ["*c2fo*", "*office365*", "*microsoft*", "*slack*", "*jetbrains*", "*datadoghq*", "*aws.amazon*", "*honeycomb.jira*", "*docs.google.com*", "*drive.google.com*", "*forms.gle*", "*localhost:*", "*zoom.us*", "*1password*", "*atlassian*", "*stitchdata*", "*talend*"],
      browser: "/Applications/Google Chrome.app"
    },
    {
      match: finicky.matchDomains("open.spotify.com"),
      browser: "Spotify"
    },
    {
      match: finicky.matchHostnames(['teams.microsoft.com']),
      browser: 'com.microsoft.teams',
      url: ({ url }) =>
        ({ ...url, protocol: 'msteams' }),
    },
  ]
};
