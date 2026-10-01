/* Omarchy colours for Firefox's interface (tabs, toolbar, menus).
   Rendered by Omarchy on every theme change; the profile's chrome/userChrome.css links to the result.
   Needs toolkit.legacyUserProfileCustomizations.stylesheets = true (set by install.sh via user.js). */

:root {
  --lwt-accent-color: {{ dark_background }} !important;
  --lwt-text-color: {{ foreground }} !important;
  --lwt-inactive-accent-color: {{ darker_background }} !important;

  --toolbar-bgcolor: {{ background }} !important;
  --toolbar-color: {{ foreground }} !important;
  --toolbarbutton-icon-fill: {{ foreground }} !important;

  --tab-selected-bgcolor: {{ background }} !important;
  --tab-selected-textcolor: {{ bright_foreground }} !important;
  --tab-loading-fill: {{ accent }} !important;

  --toolbar-field-background-color: {{ lighter_background }} !important;
  --toolbar-field-color: {{ foreground }} !important;
  --toolbar-field-focus-background-color: {{ lighter_background }} !important;
  --toolbar-field-focus-color: {{ bright_foreground }} !important;
  --toolbar-field-focus-border-color: {{ accent }} !important;

  --arrowpanel-background: {{ lighter_background }} !important;
  --arrowpanel-color: {{ foreground }} !important;
  --arrowpanel-border-color: {{ muted }} !important;

  --sidebar-background-color: {{ dark_background }} !important;
  --sidebar-text-color: {{ foreground }} !important;

  --focus-outline-color: {{ accent }} !important;
  --color-accent-primary: {{ accent }} !important;
  --button-primary-bgcolor: {{ accent }} !important;
  --button-primary-color: {{ background }} !important;
}

#navigator-toolbox {
  background-color: {{ dark_background }} !important;
  border-bottom-color: {{ muted }} !important;
}

::selection {
  background-color: {{ selection }} !important;
}
